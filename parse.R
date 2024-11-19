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

#' @title Remove Markdown Comments in String via Regular Expressions
#' @param x A character string.
#' @return A character string without markdown comments.
rm_md_comments <- function(x) {
    rgx <- "<![-]{2,3}(.|\\s|\\r)*?[-]{2,3}>"
    gsub(pattern = rgx, replacement = "", x)
}

#' @title Parse Markdown to DataFrame
#' @param filename The input filename of the Markdown file.
#' @return A data frame containing parsed sections in tidy format.
parse_md_to_csv <- function(filename) {
    # Parse the markdown file
    parsed_txt <- parsermd::parse_rmd(filename)
    # Extract unique sections
    sections <- unique(stats::na.omit(unlist(parsermd::rmd_node_sections(parsed_txt))))
    # Convert parsed text to a data frame
    df_parsed <- as.data.frame(parsed_txt)   
    # Filter rows where type is "rmd_markdown"
    df_parsed <- df_parsed[df_parsed$type == "rmd_markdown", ]  
    # Combine the 'ast' field (list of character vectors) into a single string
    df_parsed$ast <- sapply(df_parsed$ast, function(x) paste(x, collapse = "\n"))
    # Select only the relevant columns: 'sec_h1' (heading) and 'ast' (text)
    df_parsed <- df_parsed[, c("sec_h1", "ast")]
    colnames(df_parsed) <- c("heading", "text") 
    # Create a data frame for all sections
    sections_df <- data.frame(heading = sections, stringsAsFactors = FALSE) 
    # Merge parsed content with the full list of sections
    df_parsed <- merge(sections_df, df_parsed, by = "heading", all.x = TRUE, sort = FALSE) 
    # Sort rows by the order of sections
    df_parsed <- df_parsed[match(sections, df_parsed$heading), ]
    # Clean up the text by removing markdown comments and trimming whitespace
    df_parsed$text <- rm_md_comments(trimws(df_parsed$text))  
    # Convert to wide format with headings as column names
    result <- parsermd::as_tibble(setNames(as.list(df_parsed$text), df_parsed$heading))
    return(result)
}

#' @title Parse Tidy DataFrame Back to Markdown Without For Loop
#' @param x A data frame containing parsed sections in tidy format.
#' @return Writes the reconstructed Markdown to the specified file.
parse_csv_to_md <- function(x) {
    filename <- sprintf("items/tiger_item_%03d.md", x$id_item)
    output <- vector(mode = "list", length = nrow(x))
    for(i in seq_len(nrow(x))) {
        output[[i]] <- unlist(mapply(function(section, content) {
            # Add the header
            header <- paste0("# ", section)
            # Combine header, content, and a blank line
            c(header, content, "")
        }, names(x[i, ]), as.list(x[i, ]), SIMPLIFY = FALSE))
        writeLines(output[[i]], filename[i])
    }
    cli::cli_alert_success("Erfolgreich Data-Frame in .md-Dateien übertragen, siehe: {.file {file.path(getwd(), 'items')}}")
}


# Reihenfolge:
# 1. Neues Item generieren durch Funktion `create_new_item()`
# 2. Erstellte Datei mit Inhalt füllen (nach Template-Vorgaben)
# 3. Nach Fertigstellung des Items: Überprüfung
# 4. Möglicherweise Überarbeitungsschleife + erneute Überprüfung
# 5. Neues Item mit in die Itemdatenbank aufnehmen durch Funktion `update_item_db()`

# Validation Functions:
validate_id_item <- function(x) {
    x <- suppressWarnings(as.integer(x))
    if(!is.integer(x) | x <= 0 | is.na(x)) {
        cli::cli_alert_danger("Der Wert für die Variable {.field id_item} muss eine positive ganze Zahl sein.")
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field id_item korrekt.}")
    }
}

is_img_path <- function(path) {
  img_regex <- "\\.(jpg|jpeg|png|gif|bmp|tiff|webp)$"
  grepl(img_regex, path, ignore.case = TRUE)
}

validate_stimulus_image <- function(x) {
    if(!is.na(x$stimulus_image)) {
        if(!is_img_path(x$stimulus_image)) {
            cli::cli_alert_danger("Eingabe für Variable {.field stimulus_image} ist kein Pfad mit Bild")
            return(FALSE)
        } else {
            cli::cli_alert_success("Eingabe für Variable {.field stimulus_image} korrekt.")
        }
    }
}

validate_answeroptions <- function(x) {
    
}

validate_str <- function(x, var, valid, dist_len) {
    if(!x %in% valid) {
        str_dist <- stringdist::stringdist(valid, x, method = "lv")
        if(min(str_dist) < dist_len) {
            nearest_match <- which.min(str_dist)
            cli::cli_alert_danger(c("Invalide Eingabe für Variable {.field {var}}: {.arg {x}}.", "Muss einer dieser Kategorien sein: {.arg {valid}}.", "Meintest du {.arg {valid[nearest_match]}}?"))
        } else {
            cli::cli_alert_danger("Invalide Eingabe für Variable {.field {var}}: {.arg {x}}. Muss einer dieser Kategorien sein: {.arg {valid}}")
        }
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field {var}} korrekt.")
    }
}

valid_names <- list(
    learning_area = c('Deskriptivstatistik', 'Grundlagen der Inferenzstatistik', 'Wahrscheinlichkeit', 'Zusammenhangsmaße', 'Regression', 'Poweranalyse', 'Gruppentests'),
    type_item = c('content', 'coding'),
    bloom_taxonomy = c('knowledge', 'comprehension', 'application'),
    theo_diff = c('easy', 'medium', 'hard'),
    type_stimulus = c('text', 'image'),
    type_answer = c('text', 'image')
)


names(valid_names)

validate_input <- function(x) {
    validate_id_item(x$id_item)
    for(nm in names(valid_names)) validate_str(x = unlist(x[, nm]), var = nm, valid = valid_names[[nm]], dist_len = 5)
    validate_stimulus_image(x)
}

validate_input(df_parsed)

df_parsed$stimulus_image


df_tiger <- readr::read_csv("data_item_tiger.csv")

 <- parse_md_to_csv("items/tiger_item_001.md")




