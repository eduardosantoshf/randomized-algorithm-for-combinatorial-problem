from graph import Graph
import matplotlib.pyplot as plot
from matplotlib.pyplot import figure
import json
from pprint import pprint

def compute_results(
    maximum_nodes_number: int, 
    maximum_edges_number: list, 
    algorithm: str):

    data = dict()
    for m in maximum_edges_number:
        for n in range(1, maximum_nodes_number + 1):
            g = Graph().random_graph(n, 93107, m)
            minimum_weighted_closure, iterations, execution_time, solutions_number = \
                g.find_minimum_weighted_closure(algorithm = algorithm)
            
            #print("\n\nNumber of nodes: ", n)
            #print("Maximum number of edges: ", m)
            #print("Iterations: ", iterations)
            #print("Number of solutions found: ", solutions_number)
            #print("Minimum Weighted Closure:", minimum_weighted_closure)
            #print("Execution time: ", execution_time)

            data[n] = [
                iterations, 
                solutions_number, 
                minimum_weighted_closure, 
                execution_time
            ]

        with open("results/" + algorithm + "_search/" + str(m) + ".txt", 'w') as file:
            file.write(json.dumps(data))

def compare(comparison: str, maximum_edges_number: float):
    exhaustive_data = dict()
    greedy_data = dict()
    
    with open("results/exhaustive_search/" + str(maximum_edges_number) + ".txt", 'r') as file:
        exhaustive_data = json.load(file)

    with open("results/greedy_search/" + str(maximum_edges_number) + ".txt", 'r') as file:
        greedy_data = json.load(file)

    if comparison == "iterations":
        t = "Iterations" 
        ylabel = "iterations"
        c = 0
    if comparison == "solutions_number":
        t = "Solutions Number" 
        ylabel = "number of solutions"
        c = 1
    if comparison == "execution_time": 
        t = "Execution Time" 
        ylabel = "execution time (s)"
        c = 3

    exhaustive_nodes = [n for n in exhaustive_data.keys()]
    greedy_nodes = [n for n in greedy_data.keys()]

    exhaustive_execution_times, greedy_execution_times = [], []

    for node in exhaustive_data.keys():
        exhaustive_execution_times.append(exhaustive_data[node][c])
        greedy_execution_times.append(greedy_data[node][c])

    fig, axs = plot.subplots(2, figsize=(7, 6))

    axs[0].set_title("Exhaustive Search " + t)
    axs[0].set_xlabel("number of nodes", fontsize = 8)
    axs[0].set_ylabel(ylabel, fontsize = 8)
    axs[0].plot(exhaustive_nodes, exhaustive_execution_times, color = 'b')

    axs[1].set_title("Greedy Search " + t)
    axs[1].set_xlabel("number of nodes", fontsize = 8)
    axs[1].set_ylabel(ylabel, fontsize = 8)
    axs[1].plot(greedy_nodes, greedy_execution_times, color = 'r')

    fig.tight_layout(pad = 2)

    plot.show()
        
            
        

if __name__ == '__main__':
    maximum_nodes_number = 25
    maximum_edges_number = [0.125, 0.25]

    compute_results(maximum_nodes_number, maximum_edges_number, "exhaustive")
    compute_results(maximum_nodes_number, maximum_edges_number, "greedy")

    #compare("execution_time", 0.125)

