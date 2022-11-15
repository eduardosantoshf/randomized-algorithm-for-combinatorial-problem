from turtle import pos
from typing import Tuple
import networkx as nx
import random as rand
from pprint import pprint
import ast
import time

Point = Tuple[int, int]

class Graph:

    def __init__(self):
        self.nodes = dict()
        self.edges = dict()
        self.solution = dict()

    @property
    def size(self):
        return len(self.nodes)

    def add_node(self, node: Point, weight: int):
        self.nodes[node] = weight

        return self
    
    def add_edge(self, node1: Point, node2: Point):
        self.edges.setdefault(node1, []).append(node2) # add edge node1 -> node2

        return self

    def read_graph(self, filename: str):
        self.nodes.clear()
        self.edges.clear()

        try:
            file = open(filename, "r")
        except FileNotFoundError:
            print(f"Error! File not found!")
            exit(1)

        l = 0
        while file:
            line = file.readline()
            l += 1

            nodes_number = int(line) # number of nodes = number of lines to read

            nodes = dict()
            edges = dict()
            for v in range(1, nodes_number + 1):
                x, y, weight, *neighbours = [int(w) for w in \
                                            file.readline().split()]

                l += 1

                nodes[v] = (x, y)
                self.add_node((x, y), weight) # {node: weight}

                for n in neighbours: # neighbour nodes are nodes 
                                     # that share an edge
                    edges.setdefault(v, []).append(n) 

            break

        for e in edges.keys():
            for n in edges[e]: self.add_edge(nodes[e], nodes[n])

        #print(f'nodes: ', self.nodes)
        #print(f'edges: ', self.edges)

        return self

    def random_graph(self, size: int, seed: int, edge_probability: int = 0.5):
        self.nodes.clear()
        self.edges.clear()

        rand.seed(seed)

        for _ in range(size):
            while True:
                x, y = (rand.randint(1, 20), rand.randint(1, 20)) # generate
                                                                  # random
                                                                  # coordinates
                if not (x, y) in self.nodes: break # continue if point exists

            self.add_node((x,y), rand.randint(1, 10))
        
        #print(f'nodes: ', self.nodes)

        for n1 in self.nodes:
            for n2 in self.nodes:
                if rand.random() < edge_probability and n1 != n2:
                    self.add_edge(n1, n2) # generate edges until given max

        #print(f'edges: ', self.edges)
        
        return self

    def find_minimum_weighted_closure(self, algorithm: str = "randomized"):
        if algorithm == "randomized":
            self.solution, iterations, execution_time, solutions_number = RandomizedAlgorithm(self.nodes, self.edges).calculate()

        return self.solution, iterations, execution_time, solutions_number
    
    def draw_graph(self, ax = None):
        graph_drawer = GraphDrawer()
        graph_drawer.draw_graph(self.nodes, self.edges, self.solution)

class GraphDrawer:

    def draw_graph(
        self, 
        nodes: dict(), 
        edges: dict(), 
        solution: dict() = None, 
        ax = None
    ):

        graph = nx.DiGraph()

        for key in edges.keys():
            for value in edges[key]:
                graph.add_edge(key, value)
        
        positions = {x: x for x in nodes}

        nx.draw(
            graph,
            pos = positions,
            nodelist = nodes,
            edge_color = '#000000',
            node_size = 500,
            node_color = '#9999FF',
            width = 1,
            ax = ax,
            arrows = True,
            arrowsize = 10,
            arrowstyle='->'
        )

        nx.draw_networkx_nodes(
            graph,
            pos = positions,
            nodelist = solution,
            node_size = 500,
            node_color = '#99FF99',
            ax = ax)

        nx.draw_networkx_labels(
            graph,
            pos = positions,
            labels = nodes,
            font_color = 'black',
            font_size = 8
        )


class RandomizedAlgorithm:

    global compute_powerset

    def __init__(self, nodes: dict(), edges: dict()):
        self.nodes = nodes
        self.edges = edges
        self.size = len(nodes)

    def compute_powerset(lst):
        l = len(lst)

        powerset = []
        for i in range(1 << l):
            powerset.append([lst[j] for j in range(l) if (i & (1 << j))])

        return powerset
    
    def calculate(self):

        start = time.time()

        # a power set of a set S is the set of all subsets of S, 
        # including the empty set and S itself
        powerset = compute_powerset([n for n in self.nodes.keys()])
        
        iterations = 0

        closures = []
        for possible_closure in powerset:
            #print("possible closure: ", possible_closure)

            out_edges = []
            for node in possible_closure:
                #print("node: ", node)
                if node in self.edges.keys():
                    # node has no edge to a node outside the subset
                    #out_edges.extend(x for x in self.edges[node]\
                    #                if x not in out_edges\
                    #                and x not in possible_closure)

                    for x in self.edges[node]:
                         if x not in out_edges and x not in possible_closure:
                            iterations += 1

                            out_edges.extend([x])
                    
                    #print("out edges: ", out_edges)
                    
            #print("edges to nodes external to the possible closure: ", out_edges)
            #print("")

            if not out_edges and possible_closure: # if no edges leave the 
                                # possible closure and its value != None,
                                # then this subset is a closure
                closures.append(possible_closure)
        
        #print("closures: ", closures)

        closures_weights = dict()
        for closure in closures:
            closures_weights[str(closure)] = sum([self.nodes[node] \
                                                for node in closure])
        
        end = time.time()

        return ast.literal_eval(min(closures_weights, key = closures_weights.get)), iterations, end - start, len(closures)