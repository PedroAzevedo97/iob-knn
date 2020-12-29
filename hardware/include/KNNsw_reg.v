//START_TABLE sw_reg
//<<<<<<< HEAD


reg KNN_RESET; //Timer soft reset
reg KNN_ENABLE; //Timer enable

`SWREG_W(KNN_RESET, 1, 0)
`SWERG_W(KNN_ENABLE,1,0)

`SWREG_W(KNN_TEST_POINT,DATA_W,0) // Resgisto para o test point
`SWREG_W(KNN_TEST_LABEL,LABEL_W,0) // Label do test point
`SWREG_BANKW(KNN_DATASET,DATA_W,0,DATASET_SIZE) // Banco de registos com os valores do Dataset (45)
`SWREG_BANKR(KNN_LABEL_SET, LABEL_W,0,DATASET_SIZE) // Label  (450)


//`SWREG_W(KNN_RESET,          1, 0) //KNN soft reset
//`SWREG_W(KNN_ENABLE,         1, 0) //KNN enable

//`SWREG_W(KNN_B,         DATA_W, 0) //Point B
//`SWREG_W(KNN_LABEL,	     LABEL, 0) //Label Point B

//`SWREG_BANKR(KNN_INFO,   LABEL, 0, 450) //Bank of Labels
//`SWREG_BANKW(KNN_A, 	DATA_W, 0,  45) //Point A Bank
