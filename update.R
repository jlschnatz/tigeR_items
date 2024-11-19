
update_item_db <- function(new_filename) {
    validate_input(new_filename)
    df_item <- do.call(rbind, lapply(dir(file.path(getwd(), "items"), full.names = TRUE), parse_md_to_csv))
    readr::write_csv(df_item, "data_item_tiger.csv")
    cli::cli_alert_info("Neue CSV-Datei beschrieben, siehe {.file {normalizePath('data_item_tiger.csv')}}")
    con <- DBI::dbConnect(drv = RSQLite::SQLite(), "db_item.sqlite")
    DBI::dbWriteTable(con, "item_db", df_item, overwrite = TRUE)
    cli::cli_alert_info("Datenbank beschrieben, siehe {.file {normalizePath('db_item.sqlite')}}")
    cli::cli_alert_success("Fertig!")
}

update_item_db(filename)

