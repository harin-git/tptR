TPT_dict_raw <-readxl::read_xlsx("data_raw/TPT_dict.xlsx")
TPT_dict <- psychTestR::i18n_dict$new(TPT_dict_raw)
usethis::use_data(TPT_dict, overwrite = TRUE)
