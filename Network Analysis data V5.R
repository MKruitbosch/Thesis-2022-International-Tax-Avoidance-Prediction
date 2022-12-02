# Loading in the library's needed for network analysis and some data processing

library(readxl)
library(dplyr)
library(igraph)

# Load in the CSV with the multimodal edges

Combined_nodes_board_members_and_companys <- read_excel("C:/Users/Gebruiker/Desktop/De Map/Wat wil je bereiken/Uni/Master Data Science/Scriptie/Network Analytics/Network Analytics data/Combined nodes board members and companys.xlsx")
networkdatapro2 <- read.csv("C:/Users/Gebruiker/Desktop/De Map/Wat wil je bereiken/Uni/Master Data Science/Scriptie/Network Analytics/Network Analytics data/networkdatapro3.csv", row.names=1, sep=";", quote="")


# Lets go make a network

set.seed(19960203)
net <- graph_from_incidence_matrix(networkdatapro2)

col <- c("yellow", "blue")
shape <- c("circle", "square")

set.seed(19960203)
net_simple <- simplify(net, remove.multiple = TRUE, remove.loops = TRUE)

set.seed(19960203)
plot(net_simple, vertex.label = NA, vertex.size = 0.1, vertex.size2 = 0.1, vertex.shape = shape[as.numeric(V(net_simple)$type) + 1], vertex.color = col[as.numeric(V(net_simple)$type) + 1], edge.width = 0.01)

# Complete takeover

V(net_simple)$degree <- degree(net_simple)                        # Degree centrality
V(net_simple)$eig <- evcent(net_simple)$vector                    # Eigenvector centrality
V(net_simple)$hubs <- hub.score(net_simple)$vector                # "Hub" centrality
V(net_simple)$authorities <- authority.score(net_simple)$vector   # "Authority" centrality
V(net_simple)$closeness <- closeness(net_simple)                  # Closeness centrality
V(net_simple)$betweenness <- betweenness(net_simple)              # Vertex betweenness centrality

data_centrality5 <- data.frame(row_names   = V(net_simple)$name,
                              degree      = V(net_simple)$degree,
                              closeness   = V(net_simple)$closeness,
                              betweenness = V(net_simple)$betweenness,
                              eigenvector = V(net_simple)$eig,
                              hubs        = V(net_simple)$hubs,
                              authorities = V(net_simple)$authorities)

data_centrality2 <- data_centrality5[,-1]
row.names(data_centrality2) <- data_centrality5[,1]


install.packages("writexl")
library("writexl")
library("xlsx")
file <- paste(tempdir(), "\\data_centrality5")
write_xlsx(data_centrality5, path = tempfile(fileext = ".xlsx"))
write_xlsx(x = data_centrality5, path = "C:/Users/Gebruiker/Desktop/De Map/Wat wil je bereiken/Uni/Master Data Science/Statistics and Methodology/lab6/code/Network Analysis data V1/data_centrality5.xlsx")

