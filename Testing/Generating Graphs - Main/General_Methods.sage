# For runtime
from datetime import datetime
import logging

#Most up to date version - 7/9/2021 2:49pm HST
"""
Description: These are methods to make our computation/experimentation sorted and easier to read.  It runs on Python 3.9 (This is great!).  To test these functions in cocalc you will see that there is no run button so you have to open the terminal on terminal and enter "~$ sage Methods.sage". If you would like to test/implement these methods run "%attach Methods.sage" in a sage worksheet(.sagews) or type "attach("code.sage")" into the terminal.  Feel free to edit this.
"""

"""
Definition 1: A graph G is induced H-Saturated if there does not exist an induced H-subgraph in G, but the addition of any edge e from the complement of G does construct an induced H-subgraph.

Definition 2 (Behrens et. al.): A graph G is induced H-Saturated if there does not exist an induced H-subgraph in G, but the addition of any edge e from the complement of G does construct an induced H-subgraph,as well as the deletion of any edge e from G.
"""

#--------------------------------------------------------------------------------------------------------#
#----------Our Basic Testing Methods for Induced H-Saturated Graphs under Definition 1: Group 1----------#
#--------------------------------------------------------------------------------------------------------#

def has_induced_subgraph(G, H):
    """
    Finds whether a graph G has an induced subgraph H

    @param G: Graph - A sage graph
    @param H: Subgraph - A sage graph
    @return: boolean
    """
    # If there exists an induced H-subgraph in G
    if G.subgraph_search(H, induced=True):
        return True
    else:
        return False

def find_induced_subgraphs(G, H):
    """
    Finds all induced subgraphs H in G

    @param G: Graph - A sage graph
    @param H: Subgraph - A sage graph
    @return: list of edges or None
    """
    ind_subgraphs = []
    # If there is an induced H-subgraph in G
    if G.subgraph_search(H, induced=True):
        # Append all induced H-subgraphs to a list
        for i in G.subgraph_search(H, induced = True):
            ind_subgraphs.append(i)
    # If ind_subgraphs is empty
    if not ind_subgraphs:
        return None
    else:
        return ind_subgraphs


def is_indsat(G, H, definition = 1, unique = False, incl_completeGraph = False):
    """
    Finds whether a graph G is induced H-saturated under definiton 1

    @param G: Graph - A sage graph
    @param H: Subgraph - A sage graph
    @param definition: int - Definition of induced H-saturation
    @param unique: boolean - test for unique induced H-saturation
    @param incl_completeGraph: boolean - include complete graphs
    @return: boolean
    """
    logging.basicConfig(level=logging.DEBUG)
    # Check if G has an induced H-subgraph or G is isomorphic to a complete graph
    if has_induced_subgraph(G,H):
        # If so, G is not an induced H-saturated graph by our definition
        logging.info("G has an induced subgraph H")
        return False
    if incl_completeGraph == False:
        if G.is_isomorphic(graphs.CompleteGraph(G.order())):
            logging.info("G is a Complete Graph")
            return False
    # Check to see if the addition of every edges from the complement of G constructs an induced H-subgraph
    G_comp = G.complement()
    G_comp_edges = G_comp.edges()
    for (x, y, z) in G_comp_edges:
        G.add_edge(x, y);
        # if the addition of any edge from the complement of G does not construct an induced H-subgraph
        find_subgraph = not G.subgraph_search(H, induced = True)
        if unique == True:
            if G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1:
                logging.info("The addition of edge {0} does not make a unique induced H-subgraph".format((x,y)))
                return False
        if not G.subgraph_search(H, induced = True):
            logging.info("The addition of edge {0} does not make an induced H-subgraph".format((x,y)))
            return False
        G.delete_edge(x, y)
    if definition == 2:
        for (x, y, z) in G.edges():
            G.delete_edge(x, y)
            if unique == True:
                # if the deletion of any edge from G does not construct a unique induced H-subgraph
                if G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1:
                    logging.info("The deletion of edge {0} does not make a unique induced H-subgraph".format((x,y)))
                    return False
            # if the deletion of any edge from G does not construct an induced H-subgraph
            if not G.subgraph_search(H, induced = True):
                logging.info("The deletion of edge {0} does not make an induced H-subgraph".format((x,y)))
                return False
            G.add_edge(x, y)
    # if G survives these cases
    return True

def find_failed(G, H, definition = 1, unique = False, incl_completeGraph = False):
    """
    Finds the edges from the complement of the graph G that do not satisfy the induced H-saturated condition; that is, the
    edges that are added to the graph G from the complement of G that do not construct an induced H-subgraph

    @param G: Graph - A sage graph
    @param H: Subgraph - A sage graph
    @param definition: int - Definition of induced H-saturation
    @param unique: boolean - test for unique induced H-saturation
    @param incl_completeGraph: boolean - include complete graphs
    @return: boolean
    """
    logging.basicConfig(level=logging.DEBUG)
    failed = []
    # Check if G has an induced H-subgraph or G is isomorphic to a complete graph
    if has_induced_subgraph(G,H):
        # If so, G is not an induced H-saturated graph by our definition
        logging.info("G has an induced subgraph H")
        return False
    if incl_completeGraph == False:
        if G.is_isomorphic(graphs.CompleteGraph(G.order())):
            logging.info("G is a Complete Graph")
            return False
    # Check to see if the addition of every edges from the complement of G constructs an induced H-subgraph
    G_comp = G.complement()
    G_comp_edges = G_comp.edges()
    for (x, y, z) in G_comp_edges:
        G.add_edge(x, y);
        # if the addition of any edge from the complement of G does not construct an induced H-subgraph
        find_subgraph = not G.subgraph_search(H, induced = True)
        if unique == True:
            if G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1:
                logging.info("The addition of edge {0} does not make a unique induced H-subgraph".format((x,y)))
                failed.append((x,y))
        elif not G.subgraph_search(H, induced = True):
            logging.info("The addition of edge {0} does not make an induced H-subgraph".format((x,y)))
            failed.append((x,y))
        G.delete_edge(x, y)
    if definition == 2:
        for (x, y, z) in G.edges():
            G.delete_edge(x, y)
            if unique == True:
                # if the deletion of any edge from G does not construct a unique induced H-subgraph
                if G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1:
                    logging.info("The deletion of edge {0} does not make a unique induced H-subgraph".format((x,y)))
                    failed.append((x,y))
            # if the deletion of any edge from G does not construct an induced H-subgraph
            elif not G.subgraph_search(H, induced = True):
                logging.info("The deletion of edge {0} does not make an induced H-subgraph".format((x,y)))
                failed.append((x,y))
            G.add_edge(x, y)
    # if G survives these cases
    if not failed:
        return True
    else:
        False


def findCombinations(A, k, i=0, out=[]):
 
    # base case: if the combination size is `k`, print it
    if len(out) == k:
        print(out)
        return
 
    # start from the previous element in the current combination
    # till the last element
    j = i
    while j < len(A):
 
        # add current element `A[j]` to the solution and recur with the
        # same index `j` (as repeated elements are allowed in combinations)
        out.append(A[j])
        findCombinations(A, k, j, out)
 
        # backtrack: remove the current element from the solution
        out.pop()
 
        # code to handle duplicates – skip adjacent duplicates
        while j < len(A) - 1 and A[j] == A[j + 1]:
            j = j + 1
 
        j = j + 1


# #---------------------------------------------------------------------------------#
# #--------------------------------------Testing------------------------------------#
# #---------------------------------------------------------------------------------#

# def comb_group1_def1(G,H):
#     """
#     Combines the Group 1 methods into one method under definition 2

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: string
#     """
#     # Start runtime
#     startTime = datetime.now()
#     print("Under Definition 1 ---------->")

#     print("---------------------------------------------------------------" + "\n" + "Does G have an induced subgraph H?" + "\n" + str(
#     has_induced_subgraph(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Find all induced subgraphs H in G:" + "\n" + str(
#     find_induced_subgraphs(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Is G induced H-saturated?" + "\n" + str(
#     is_indsat_def1(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Find all failed edges not making G an induced H-saturated graph, if there is no H-subgraph to begin with:" + "\n" + str(find_failed_def1(G, H)))

#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------")

#----------------------------------------------------------------------------------------------------#
#-----------------Method finding Induced H-Saturated Graphs on n vertices----------------------------#
#----------------------------------------------------------------------------------------------------#

def find_indsat_graphs(n, H, c = True, definition = 1, unique = False, incl_completeGraph = False, file = None):
    """
    Finds induced H-saturated graphs from G where G is of order n under definition 1

    @param n: int -  The order of G
    @param H: Subgraph - A sage graph
    @param c: connected graph - boolean
    @param definition: int - Definition of induced H-saturation
    @param unique: boolean - test for unique induced H-saturation
    @param incl_completeGraph: boolean - include complete graphs
    @return: string
    """
    indSatGraphs = []
    # Begin runtime
    startTime = datetime.now()
    if not c:
        graph_gen_str = "{0}".format(n)
    else:
        graph_gen_str = "{0} -c".format(n)
    for G in graphs.nauty_geng(graph_gen_str):
        # Draw graph and print edge set
        if is_indsat(G, H, definition, unique, incl_completeGraph):
            indSatGraphs.append(G.edges(labels = False))
    # If there are no induced H-saturated graphs G

    if not indSatGraphs:
        print("No {0} {1} induced H-saturated graphs for n = {2} under definition {3}".format("connected" if c == True else "", "unique" if unique == True else "", n, definition), file = file)
    else:
        print("List of graph edge sets: {0} \n---------------------------------------------------------------\n Total number of {1} {2} induced H-saturated graphs G on {3} vertices under definition {4}: {5}".format( str(indSatGraphs),"connected" if c == True else "", "unique" if unique == True else "", n, definition, len(indSatGraphs)), file = file)
    # End runtime
    print("---------------------------------------------------------------\nRUNTIME\n{0}\n---------------------------------------------------------------".format(datetime.now() - startTime), file = file)


# #-----------------------------------------------------------------------------------------------------------#
# #-----Method finding UNIQUE Induced H-Saturated Graphs in some Graph G of order n under Definition 1--------#
# #-----------------------------------------------------------------------------------------------------------#
# def find_unique_indsat_graphs_def1(n, H, c = True):
#     """
#     Finds uniquely induced H-saturated graphs from G where G is of order n under definition 1

#     @param n: int -  The order of G
#     @param H: Subgraph - A sage graph
#     @param c: connected graph - boolean
#     @return: str
#     """
#     indSatGraphs = []
#     # Begin runtime
#     startTime = datetime.now()
#     if not c:
#         graph_gen_str = "{0}".format(n)
#     else:
#         graph_gen_str = "{0} -c".format(n)
#     for G in graphs.nauty_geng(graph_gen_str):
#         # Draw graph and print edge set
#         if is_unique_indsat_def1(G,H):
#             G.show()
#             indSatGraphs.append(G.edges(labels = False))
#             print("Edge set for above graph: " + str(G.edges(labels = False)))
#     # If there are no induced H-saturated graphs G
#     if not indSatGraphs:
#         print("No Induced H-Saturated Graphs for n = " + str(n) + " under definition 1")
#     else:
#         print("List of graph edge sets: " + str(indSatGraphs) + "\n" + "---------------------------------------------------------------" + "\n" + "Total number of induced H-saturated graphs G on " + str(n) + " vertices under definition 1: " + str(len(indSatGraphs)))
#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------")


# #--------------------------------------------------------------------------------------------------------------------------------#
# #-----Method finding Induced H-Saturated Graphs in some Graph G of order n under Definition 1 implementing multithreading--------#
# #--------------------------------------------------------------------------------------------------------------------------------#

# def find_indsat_graphs_def1_parallel(n, H, res, mod, file, c = True):
#     """
#     Finds induced H-saturated graphs from G where G is of order n under definition 1 using multithreading.  The graph generator nauty_geng is partitioned res/mod.

#     @param n: int - The order of G
#     @param H: Subgraph - A sage graph
#     @param res: residual - partition number 0,...,mod-1
#     @param mod: modulo - number of partitions
#     @param file: txt file where output is saved
#     @param c: connected graph - boolean
#     @return:
#     """
#     logging.info("Thread %s: starting", res)
#     indSatGraphs = []
#     # Begin runtime
#     startTime = datetime.now()
#     if not c:
#         graph_gen_str = "{0} {1}/{2}".format(n, res, mod)
#     else:
#         graph_gen_str = "{0} -c {1}/{2}".format(n, res, mod)
#     for G in graphs.nauty_geng(graph_gen_str):
#         # Draw graph and print edge set
#         if is_indsat_def1(G,H):
#             indSatGraphs.append(G.edges(labels = False), file = file)
#     # If there are no induced H-saturated graphs G
#     if not indSatGraphs:
#         print("No Induced H-Saturated Graphs for n = " + str(n) + " under definition 1", file = file)
#     else:
#         print("List of graph edge sets: " + str(indSatGraphs) + "\n" + "---------------------------------------------------------------" + "\n" + "Total number of induced H-saturated graphs G on " + str(n) + " vertices under definition 1: " + str(len(indSatGraphs)), file = file)
#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------", file = file)
#     logging.info("Thread %s: finishing", res)



# #----------------------------------------------------------------------------------------------------#
# #-----Method finding Induced H-Saturated Graphs in some Graph G of order n under Definition 2--------#
# #----------------------------------------------------------------------------------------------------#

# def find_indsat_graphs_def2(n, H, c = True):
#     """
#     Finds induced H-saturated graphs from G where G is of order n under definition 2

#     @param n: int -  The order of G
#     @param H: Subgraph - A sage graph
#     @param c: connected graph - boolean
#     @return: str
#     """
#     indSatGraphs = []
#     # Begin runtime
#     startTime = datetime.now()
#     if not c:
#         graph_gen_str = "{0}".format(n)
#     else:
#         graph_gen_str = "{0} -c".format(n)
#     for G in graphs.nauty_geng(graph_gen_str):
#         # Draw graph and print edge set
#         if is_indsat_def2(G,H):
#             G.show()
#             indSatGraphs.append(G.edges(labels = False))
#             print("Edge set for above graph: " + str(G.edges(labels = False)))
#     # If there are no induced H-saturated graphs G
#     if not indSatGraphs:
#         print("No Induced H-Saturated Graphs for n = " + str(n) + " under definition 2")
#     else:
#         print("List of graph edge sets: " + str(indSatGraphs) + "\n" + "---------------------------------------------------------------" + "\n" + "Total number of induced H-saturated graphs G on " + str(n) + " vertices under definition 2: " + str(len(indSatGraphs)))
#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------")

# #-----------------------------------------------------------------------------------------------------------#
# #-----Method finding UNIQUE Induced H-Saturated Graphs in some Graph G of order n under Definition 2--------#
# #-----------------------------------------------------------------------------------------------------------#
# def find_unique_indsat_graphs_def2(n, H, c = True):
#     """
#     Finds induced H-saturated graphs from G where G is of order n under definition 2

#     @param n: int -  The order of G
#     @param H: Subgraph - A sage graph
#     @param c: connected graph - boolean
#     @return: str
#     """
#     indSatGraphs = []
#     # Begin runtime
#     startTime = datetime.now()
#     if not c:
#         graph_gen_str = "{0}".format(n)
#     else:
#         graph_gen_str = "{0} -c".format(n)
#     for G in graphs.nauty_geng(graph_gen_str):
#         # Draw graph and print edge set
#         if is_unique_indsat_def2(G,H):
#             G.show()
#             indSatGraphs.append(G.edges(labels = False))
#             print("Edge set for above graph: " + str(G.edges(labels = False)))
#     # If there are no induced H-saturated graphs G
#     if not indSatGraphs:
#         print("No Induced H-Saturated Graphs for n = " + str(n) + " under definition 2")
#     else:
#         print("List of graph edge sets: " + str(indSatGraphs) + "\n" + "---------------------------------------------------------------" + "\n" + "Total number of induced H-saturated graphs G on " + str(n) + " vertices under definition 2: " + str(len(indSatGraphs)))
#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------")

# #---------------------------------------------------------------------------------------------------------#
# #----------Our Basic Testing Methods for Induced H-Saturated Graphs under Definition 2: Group 1-----------#
# #---------------------------------------------------------------------------------------------------------#
# def is_indsat_def2(G, H):
#     """
#     Finds whether a graph G is induced H-saturated under definiton 2

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: boolean
#     """
#     # Check if G has an induced H-subgraph or G is isomorphic to a complete graph
#     if has_induced_subgraph(G,H) | G.is_isomorphic(graphs.CompleteGraph(G.order())):
#         # If so, G is not an induced H-saturated graph by our definition
#         return False
#     # Check to see if the addition of every edges from the complement of G constructs an induced H-subgraph, as well as the deletion of any edge
#     else:
#         G_comp = G.complement()
#         G_comp_edges = G_comp.edges()
#         for (x, y, z) in G_comp_edges:
#             G.add_edge(x, y)
#             # if the addition of any edge from the complement of G does not construct an induced H-subgraph
#             if not G.subgraph_search(H, induced = True):
#                 return False
#             G.delete_edge(x, y)
#         for (x, y, z) in G.edges():
#             G.delete_edge(x, y)
#             # if the deletion of any edge from G does not construct an induced H-subgraph
#             if not G.subgraph_search(H, induced = True):
#                 return False
#             G.add_edge(x, y)
#     # if G survives these cases
#     return True

# def find_failed_def2(G, H):
#     """
#     Finds the edges from the complement of the graph G that do not satisfy the induced H-saturated condition; that is, the
#     edges that are added to the graph G from the complement of G or the edges deleted from G that do not construct an induced H-subgraph

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: list of edges or None
#     """
#     failed_edges = []
#     G_comp = G.complement()
#     G_comp_edges = G_comp.edges()
#     # search the edges in the complement of G
#     for (x, y, z) in G_comp_edges:
#         G.add_edge(x,y);
#         # if the addition of any edge from the complement of G does not construct an induced H-subgraph
#         if not G.subgraph_search(H, induced = True):
#             failed_edges.append([(x, y)])
#         G.delete_edge(x, y)
#     # search the edges in G
#     for (x, y, z) in G.edges():
#         G.delete_edge(x, y)
#         # if the deletion of any edge from G does not construct an induced H-subgraph
#         if not G.subgraph_search(H, induced = True):
#             failed_edges.append([(x,y)])
#         G.add_edge(x, y)
#     # if failed_edges is empty
#     if not failed_edges:
#         return None
#     else:
#         return failed_edges

# #---------------------------------------------------------------------------------#
# #--------------------------------Group 1: Definition 2----------------------------#
# #---------------------------------------------------------------------------------#

# def comb_group1_def2(G,H):
#     """
#     Combines the Group 1 methods into one method under definition 2

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: string
#     """
#     # Start runtime
#     startTime = datetime.now()
#     print("Under Definition 2 (Behrens et. al.) ---------->")

#     print("---------------------------------------------------------------" + "\n" + "Does G have an induced subgraph H?" + "\n" + str(
#     has_induced_subgraph(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Find all induced subgraphs H in G:" + "\n" + str(
#     find_induced_subgraphs(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Is G induced H-saturated?" + "\n" + str(
#     is_indsat_def2(G, H)))

#     print("---------------------------------------------------------------" + "\n" + "Find all failed edges not making G an induced H-saturated graph, if there is no H-subgraph to begin with:" + "\n" + str(find_failed_def2(G, H)))

#     # End runtime
#     print("---------------------------------------------------------------" + "\n" + "RUNTIME" + "\n" + str(
#     datetime.now() - startTime) + "\n" + "---------------------------------------------------------------")



# #--------------------------------------------------------------------------------------------#
# #--------------------------------Find Induced Saturation UNIQUELY----------------------------#
# #--------------------------------------------------------------------------------------------#

# # Definition 1
# def is_unique_indsat_def1(G, H):
#     """
#     Finds whether a graph G is uniquely induced H-saturated under definiton 1 such that the addtion of any edge from the complement of G to G creates a unique induced H-subgraph

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: boolean
#     """
#     # Check if G has an induced H-subgraph or G is isomorphic to a complete graph
#     if has_induced_subgraph(G,H) | G.is_isomorphic(graphs.CompleteGraph(G.order())):
#         # If so, G is not an induced H-saturated graph by our definition
#         return False
#     # Check to see if the addition of every edge from the complement of G constructs an induced H-subgraph
#     else:
#         G_comp = G.complement()
#         G_comp_edges = G_comp.edges()
#         for (x, y, z) in G_comp_edges:
#             G.add_edge(x, y);
#             # if the addition of any edge from the complement of G does not construct a unique induced H-subgraph
#             if not G.subgraph_search(H, induced = True) | G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1 :
#                 return False
#             G.delete_edge(x, y)
#     # if G survives these cases
#     return True

# # Definition 2
# def is_unique_indsat_def2(G, H):
#     """
#     Finds whether a graph G is uniquley induced H-saturated under definiton 2 such that the addtion of any edge from the complement of G to G creates a unique induced H-subgraph
#     and the deletion of any edge from G results in a unique induced H-subgraph.

#     @param G: Graph - A sage graph
#     @param H: Subgraph - A sage graph
#     @return: boolean
#     """
#     # Check if G has an induced H-subgraph or G is isomorphic to a complete graph
#     if has_induced_subgraph(G,H) | G.is_isomorphic(graphs.CompleteGraph(G.order())):
#         # If so, G is not an induced H-saturated graph by our definition
#         return False
#     # Check to see if the addition of every edge from the complement of G constructs an induced H-subgraph, as well as the deletion of any edge
#     else:
#         G_comp = G.complement()
#         G_comp_edges = G_comp.edges()
#         for (x, y, z) in G_comp_edges:
#             G.add_edge(x, y)
#             # if the addition of any edge from the complement of G does not construct a unique induced H-subgraph
#             if not G.subgraph_search(H, induced = True) | G.subgraph_search_count(H, induced=True) > 1:
#                 return False
#             G.delete_edge(x, y)
#         for (x, y, z) in G.edges():
#             G.delete_edge(x, y)
#             # if the deletion of any edge from G does not construct a unique induced H-subgraph
#             if not G.subgraph_search(H, induced = True) | G.subgraph_search_count(H, induced = True)/H.automorphism_group().order() > 1 :
#                 return False
#             G.add_edge(x, y)
#     # if G survives these cases
#     return True

# Testing
if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
#     G = Graph([(0, 4), (0, 5), (0, 7), (1, 4), (1, 6), (1, 8), (2, 5), (2, 8), (2, 9), (3, 6), (3, 7), (3, 9), (4, 8), (5, 7), (5, 8), (5, 9), (6, 9), (8, 9)])
    logging.debug("Dubugging")
    G = graphs.CompleteGraph(10)
    H = Graph({0:[1,2,3]})
    print(is_unique_indsat_def1(G, H))