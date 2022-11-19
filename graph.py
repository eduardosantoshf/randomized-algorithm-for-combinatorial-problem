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

    def find_minimum_weighted_closure(self, seed: int, max_solutions: int, max_time: int):
        self.solution, iterations, execution_time, solutions_number = \
            RandomizedAlgorithm(
                seed,
                self.nodes, 
                self.edges, 
                max_solutions, 
                max_time
            ).calculate()

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

    global compute_subsets

    def __init__(self, seed: int, nodes: dict(), edges: dict(), max_solutions, max_time):
        self.seed = seed
        self.nodes = nodes
        self.edges = edges
        self.max_solutions = max_solutions
        self.max_time = max_time
        self.size = len(nodes)

    def compute_subsets(self, lst, start):
        l = len(lst)

        # if self.max_solutions > 2^l (max number of combinations), use 2^l
        randoms = rand.sample(range(2**l), self.max_solutions) \
            if self.max_solutions \
            and (self.max_solutions <= 2**l) \
            else rand.sample(range(2**l), 2**l)

        t1 = time.time()

        subsets = []
        for i in randoms: # << is the left-shift operator, and has the 
            # effect of multiplying the left hand side by two to the power of 
            # the right hand side: x << n == x * 2**n, in this case:
            # 1 << l == 2^l -> number of subsets of the initial set (lst)

            # if time exceeds max_time, stop processing the next subsets
            if self.max_time and (time.time() - start) > self.max_time: break

            temp = []
            for j in range(l):
                if (i & (1 << j)):
                    temp.append(lst[j])

            subsets.append(temp)

        print("Processing subsets time: ", time.time() - t1)
        
        return subsets


    def calculate(self):

        start = time.time()

        subsets = compute_subsets(self, [n for n in self.nodes.keys()], start) 

        subsets.sort()

        iterations = 0

        before_processing = time.time()

        closures = []
        for possible_closure in subsets:

            #print(time.time() - start)

            out_edges = []
            for node in possible_closure:

                if node in self.edges.keys():
                    # node has no edge to a node outside the subset
                    #out_edges.extend(x for x in self.edges[node]\
                    #                if x not in out_edges\
                    #                and x not in possible_closure)

                    for x in self.edges[node]:
                         if x not in out_edges and x not in possible_closure:
                            iterations += 1

                            out_edges.extend([x])

            if not out_edges and possible_closure: # if no edges leave the 
                                # possible closure and its value != None,
                                # then this subset is a closure
                closures.append(possible_closure)

        closures_weights = dict()
        for closure in closures:
            closures_weights[str(closure)] = sum([self.nodes[node] \
                                                for node in closure])
        
        end = time.time()

        print("Processing closures time: ", end - before_processing)

        if closures_weights:
            minimum_weighted_closure = ast.literal_eval(
                min(closures_weights, key = closures_weights.get)
            )
        
        else: minimum_weighted_closure = None

        return minimum_weighted_closure, iterations, end - start, len(closures)