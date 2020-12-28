//START_TABLE sw_reg


reg KNN_RESET; //Timer soft reset
reg KNN_ENABLE; //Timer enable

`SWREG_W(KNN_RESET, 1, 0)
`SWERG_W(KNN_ENABLE,1,0)

`SWREG_W(KNN_TEST_POINT,DATA_W,0) // Resgisto para o test point
`SWREG_W(KNN_TEST_LABEL,LABEL_W,0) // Label do test point
`SWREG_BANKW(KNN_DATASET,DATA_W,0,DATASET_SIZE) // Banco de registos com os valores do Dataset
`SWREG_BANKR(KNN_LABEL_SET, LABEL_W,0,DATASET_SIZE) // Label 

