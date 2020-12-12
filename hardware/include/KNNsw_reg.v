//START_TABLE sw_reg


reg KNN_RESET; //Timer soft reset
reg KNN_ENABLE; //Timer enable

reg [DATA_W-1:0] KNN_TEST_POINT; // Fetch test point
reg [DATA_W-1:0] KNN_TEST_LABEL; //Label test point
//reg [DATA_W-1:0] KNN_DATASET [DATASET_SIZE-1:0]; //Vai buscar o Dataset (temos de alterar o nº)
