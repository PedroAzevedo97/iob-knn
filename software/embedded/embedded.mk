#exports software embedded stuff to system; KNN_DIR defined in system.mk

include $(KNN_DIR)/software/software.mk

#embeded sources
SRC+=$(KNN_SW_DIR)/embedded/iob-knn-interface.c
