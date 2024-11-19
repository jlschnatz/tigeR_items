#' @title Create a new Item from the Markdown Template
#' @param open Whether to open the new created file. Logical vector
#' @return Creates a new file based on the Markdown-Template with prefilled `id_item`
create_new_item <- function(open = TRUE) {
    max_digit_exist <- max(as.numeric(sub("tiger_item_(\\d*)\\.md", "\\1", dir(file.path(getwd(), "items"))))) 
    filename <- sprintf("items/tiger_item_%03d.md", max_digit_exist + 1)
    file.copy(from = file.path(getwd(), "skeleton.md"), to = filename)
    item_txt <- readLines(filename, warn = FALSE)
    item_txt_append <- append(item_txt, c(max_digit_exist + 1, ""), grep("learning_area", item_txt) - 1)
    writeLines(item_txt_append, filename)
    if(open) browseURL(filename, browser = getOption("browser"))
    cli::cli_alert_success("Neue md-Datei erstellt unter {.file {filename}}")
}