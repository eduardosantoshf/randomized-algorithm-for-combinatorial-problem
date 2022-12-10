from graph import Graph
import matplotlib as mpl
import matplotlib.pyplot as plot
from matplotlib.pyplot import figure
import json
from pprint import pprint

def compute_results(maximum_nodes_number: int, percentage: float):

    data1, data2, data3 = dict(), dict(), dict()
    for n in range(1, maximum_nodes_number + 1):
        g1 = Graph().random_graph(n, 93107, edge_probability = 0.25)
        g2 = Graph().random_graph(n, 93107, edge_probability = 0.25)
        g3 = Graph().random_graph(n, 93107, edge_probability = 0.25)

        minimum_weighted_closure1, iterations1, execution_time1, solutions_number1 = \
            g1.find_minimum_weighted_closure(93107, 1, 1, 0.25)
        minimum_weighted_closure2, iterations2, execution_time2, solutions_number2 = \
            g2.find_minimum_weighted_closure(93107, percentage, 1, 0.25)
        minimum_weighted_closure3, iterations3, execution_time3, solutions_number3 = \
            g3.find_minimum_weighted_closure(93107, 1, percentage, 0.25)

        print("Graphs # " + str(n) + " computed!")
        
        #print("\n\nNumber of nodes: ", n)
        #print("Maximum number of edges: ", m)
        #print("Iterations: ", iterations)
        #print("Number of solutions found: ", solutions_number)
        #print("Minimum Weighted Closure:", minimum_weighted_closure)
        #print("Execution time: ", execution_time)

        data1[n] = [iterations1, solutions_number1, minimum_weighted_closure1, execution_time1]
        data2[n] = [iterations2, solutions_number2, minimum_weighted_closure2, execution_time2]
        data3[n] = [iterations3, solutions_number3, minimum_weighted_closure3, execution_time3]

    with open("results/exhaustive.txt", 'w') as file:
        file.write(json.dumps(data1))
    with open("results/randomized_s_" + str(percentage) + ".txt", 'w') as file:
        file.write(json.dumps(data2))
    with open("results/randomized_t_" + str(percentage) + ".txt", 'w') as file:
        file.write(json.dumps(data3))

def plot_results(comparison: str, percentage: float):
    exhaustive, randomized_s, randomized_t = dict(), dict(), dict()
    
    with open("results/exhaustive.txt", 'r') as file1:
        exhaustive = json.load(file1)
    
    with open("results/randomized_s_" + str(percentage) + ".txt", 'r') as file2:
        randomized_s = json.load(file2)

    with open("results/randomized_t_" + str(percentage) + ".txt", 'r') as file3:
        randomized_t = json.load(file3)

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

    exhaustive_nodes = [n for n in exhaustive.keys()]
    randomized_s_nodes = [n for n in randomized_s.keys()]
    randomized_t_nodes = [n for n in randomized_t.keys()]

    exhaustive_execution_times, randomized_s_execution_times, randomized_t_execution_times = [], [], []

    for node in exhaustive.keys():
        exhaustive_execution_times.append(exhaustive[node][c])
    for node in randomized_s.keys():
        randomized_s_execution_times.append(randomized_s[node][c])
    for node in randomized_t.keys():
        randomized_t_execution_times.append(randomized_t[node][c])

    fig, axs = plot.subplots(3, figsize=(7, 6))

    axs[0].set_title("Exhaustive Search " + t)
    axs[0].set_xlabel("number of nodes", fontsize = 8)
    axs[0].set_ylabel(ylabel, fontsize = 8)
    axs[0].plot(exhaustive_nodes, exhaustive_execution_times, color = 'b')

    axs[1].set_title("Randomized Algorithm " + t + " (" + str(int(percentage * 100)) + "% Max Solutions)")
    axs[1].set_xlabel("number of nodes", fontsize = 8)
    axs[1].set_ylabel(ylabel, fontsize = 8)
    axs[1].plot(randomized_s_nodes, randomized_s_execution_times, color = 'r')

    axs[2].set_title("Randomized Algorithm " + t + " (" + str(int(percentage * 100)) + "% Max Execution Time)")
    axs[2].set_xlabel("number of nodes", fontsize = 8)
    axs[2].set_ylabel(ylabel, fontsize = 8)
    axs[2].plot(randomized_t_nodes, randomized_t_execution_times, color = 'r')

    fig.tight_layout(pad = 3)

    axs[0].grid(linestyle = "--",linewidth = 0.2)
    axs[1].grid(linestyle = "--",linewidth = 0.2)
    axs[2].grid(linestyle = "--",linewidth = 0.2)

    plot.show()

def compute_benchmark_graphs_results(percentage: float):
    data = dict()

    g = Graph().read_graph("graphs/SWtinyEWD.txt", 93107)

    minimum_weighted_closure1, iterations1, execution_time1, solutions_number1 = \
            g.find_minimum_weighted_closure(93107, 1, 1, 0.25)
    minimum_weighted_closure2, iterations2, execution_time2, solutions_number2 = \
            g.find_minimum_weighted_closure(93107, percentage, 1, 0.25)
    minimum_weighted_closure3, iterations3, execution_time3, solutions_number3 = \
            g.find_minimum_weighted_closure(93107, 1, percentage, 0.25)

    data["benchmark_exhaustive"] = [iterations1, solutions_number1, minimum_weighted_closure1, execution_time1]
    data["benchmark__s_" + str(percentage)] = [iterations2, solutions_number2, minimum_weighted_closure2, execution_time2]
    data["benchmark__t_" + str(percentage)] = [iterations3, solutions_number3, minimum_weighted_closure3, execution_time3]

    with open("results/benchmark_graph.txt", 'w') as file:
        file.write(json.dumps(data))

def plot_benchmark_graphs_results():
    data = dict()

    with open("results/benchmark_graph.txt", 'r') as file:
        data = json.load(file)

    iterations, solutions_number, execution_time = dict(), dict(), dict()

    for key in data.keys():
        iterations[key] = data[key][0]
        solutions_number[key] = data[key][1]
        execution_time[key] = data[key][3]

    mpl.rc('axes', labelcolor='b')

    fig, axs = plot.subplots(3, figsize=(7, 6))

    axs[0].set_xlabel('algorithm')
    axs[0].set_ylabel('iterations') 
    axs[0].bar(iterations.keys(), iterations.values(), width = 0.3)

    axs[1].set_xlabel('algorithm')
    axs[1].set_ylabel('solutions number') 
    axs[1].bar(solutions_number.keys(), solutions_number.values(), width = 0.3)

    axs[2].set_xlabel('algorithm')
    axs[2].set_ylabel('execution time')
    axs[2].bar(execution_time.keys(), execution_time.values(), width = 0.3)

    fig.tight_layout(pad = 3)

    plot.show()


if __name__ == '__main__':
    maximum_nodes_number = 25
    percentage = 0.25

    #compute_results(maximum_nodes_number, percentage)

    #plot_results("execution_time", percentage)
    #plot_results("iterations", percentage)
    #plot_results("solutions_number", percentage)

    #compute_benchmark_graphs_results(percentage)
    plot_benchmark_graphs_results()