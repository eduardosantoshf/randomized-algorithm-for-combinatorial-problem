from turtle import pos
from typing import Tuple
import networkx as nx
import random as rand
from pprint import pprint
import ast
import time
from collections import Counter

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

    def read_graph(self, filename: str, seed: int):
        self.nodes.clear()
        self.edges.clear()

        rand.seed(seed)

        try:
            file = open(filename, "r")
        except FileNotFoundError:
            print(f"Error! File not found!")
            exit(1)

        while file:
            file.readline()
            file.readline()
            nodes_number = int(file.readline())
            edges_number = int(file.readline())

            nodes = dict()
            for n in range(nodes_number):
                while True:
                    # generate random coordinates
                    x, y = (rand.randint(1, nodes_number * 2), rand.randint(1, nodes_number * 2)) 

                    if not (x, y) in self.nodes: break # continue if point exists

                nodes[n] = [(x,y), rand.randint(1, 10)]

            edges = dict()
            for _ in range(edges_number):
                node1, node2 = [int(w) for w in file.readline().split()[:2]]

                if node1 not in edges.keys():
                    edges.setdefault(node1, []).append(node2) 
                else: 
                    edges[node1].append(node2)

            break

        for n in nodes:
            self.add_node(nodes[n][0], nodes[n][1]) # {node: weight}

        for e in edges.keys():
            for n in edges[e]: self.add_edge(nodes[e][0], nodes[n][0])

        return self

    def random_graph(self, size: int, seed: int, edge_probability: float = 0.5):
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

    def find_minimum_weighted_closure(self, seed: int, max_solutions: int, max_time: int, edge_probability = float):
        self.solution, iterations, execution_time, solutions_number = \
            RandomizedAlgorithm(
                seed,
                self.nodes, 
                self.edges, 
                max_solutions, 
                max_time,
                edge_probability
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

    def __init__(self, seed: int, nodes: dict(), edges: dict(), max_solutions, max_time, edge_probability):
        self.seed = seed
        self.nodes = nodes
        self.edges = edges
        self.max_solutions = max_solutions
        self.max_time = max_time
        self.size = len(nodes)
        self.edge_probability = edge_probability

    def compute_subsets(self, lst):
        l = len(lst)

        powerset = []
        for i in range(1 << l):
            powerset.append([lst[j] for j in range(l) if (i & (1 << j))])
        
        subsets = []

        for subset in powerset:
            i = 0
            for node in subset:
                if node in self.edges:
                    for e in self.edges[node]:
                        # if node has at least one edge to another node in the subset
                        if e in subset:
                            i += 1
                            break
                else: # if node has no edge to another node
                    i += 1
                    if [node] not in subsets:
                        subsets.append([node]) 
            
            if i == len(subset): subsets.append(subset)
        
        
        return subsets # only subsets that in fact have edges between the nodes


    def calculate(self):

        subsets = compute_subsets(self, [n for n in self.nodes.keys()]) 

        iterations = 0
        start = time.time()

        # maximum number of candidate solutions
        subsets = rand.sample(subsets, round(self.max_solutions * len(subsets)))

        # maximum computation time, given by the max theoretical number of 
        # computations, multiplied by a % max_time, e.g., 
        # if max_time = 0.2 => 20% of the max computations ≈ 20% of the max 
        # computation time
        if self.max_time:
            max_iterations = (len(subsets) * round(self.size / 2) * round(self.size * self.edge_probability)) * self.max_time

        closures = []
        for possible_closure in subsets:

            if self.max_time and iterations >= max_iterations: break

            out_edges = []
            for node in possible_closure:

                if node in self.edges.keys():
                    # node has no edge to a node outside the subset
                    #out_edges.extend(x for x in self.edges[node]\
                    #                if x not in out_edges\
                    #                and x not in possible_closure)

                    for x in self.edges[node]:
                        iterations += 1

                        if x not in out_edges and x not in possible_closure:
                            out_edges.extend([x])

            # if no edges leave the possible closure and its value != None,
            # then this subset is a closure
            if not out_edges and possible_closure: 
                closures.append(possible_closure)

        closures_weights = dict()
        for closure in closures:
            closures_weights[str(closure)] = sum([self.nodes[node] \
                                                for node in closure])

        if closures_weights:
            minimum_weighted_closure = ast.literal_eval(
                min(closures_weights, key = closures_weights.get)
            )
        
        else: minimum_weighted_closure = None

        end = time.time()

        return minimum_weighted_closure, iterations, end - start, len(closures)