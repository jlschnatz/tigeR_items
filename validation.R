
# Validation Functions:
validate_id_item <- function(x) {
    x <- suppressWarnings(as.integer(x))
    if(!is.integer(x) | x <= 0 | is.na(x)) {
        cli::cli_alert_danger("Der Wert für die Variable {.field id_item} muss eine positive ganze Zahl sein.")
        return(FALSE)
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field id_item korrekt.}")
        return(TRUE)
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
            return(TRUE)
        }
    }
}

validate_answeroption <- function(x) {
    type_answer <- x$type_answer
    check <- dplyr::case_when(
        x$type_answer == "text" & x$answeroption_06 == "Frage überspringen." ~ "correct",
        x$type_answer == "text" & x$answeroption_06 != "Frage überspringen." ~ "text_false",
        x$type_answer == "image" & x$answeroption_06 != "www/skip.png" ~ "image_false",
        x$type_answer == "image" & x$answeroption_06 == "www/skip.png" ~ "correct",
    )
    if(check == "correct") {
        cli::cli_alert_success("Eingabe für Variable {.field answeroption_06} korrekt.")
        return(TRUE)
    } else if(check == "text_false") {
        cli::cli_alert_danger("Eingabe für Variable {.field answeroption_06} falsch. Müsste auf Basis von Variable {.field type_answer} = {.str {x$type_answer}} folgenden Wert haben: {.str Frage überspringen.}")
        return(FALSE)
    } else if(check == "image_false") {
        cli::cli_alert_danger("Eingabe für Variable {.field answeroption_06} falsch. Müsste auf Basis von Variable {.field type_answer} = {.str {x$type_answer}} folgenden Wert haben: {.str www/skip.png}")
        return(FALSE)
    }
}

validate_answer_correct <- function(x) {
    answer_correct <- suppressWarnings(as.numeric(x$answer_correct))
    n_answer <- sum(!is.na(unlist(x[, paste0("answeroption_0", 1:5)])))
    error_case <- is.na(answer_correct) | !rlang::is_integerish(answer_correct) | answer_correct < 1 | answer_correct > n_answer
    if(error_case) {
        cli::cli_alert_danger("Eingabe für Variable {.field answer_correct} falsch. Muss Index (Integer) der korrekten Antwort sein.")
        return(FALSE)
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field answer_correct} entspricht Formalien.")
        return(TRUE)
    }
}

validate_if_answeroption <- function(x) {
    if(x$if_answeroption_06 != "Alles klar! Du hast die Aufgabe übersprungen.") {
        cli::cli_alert_danger("Eingabe für Variable {.field if_answeroption_06} muss unverändert bleiben, bitte wähle {.str Alles klar! Du hast die Aufgabe übersprungen.}")
        return(FALSE)
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field if_answeroptions_06} entspricht Formalien.")
    }

    n_answer <- sum(!is.na(unlist(x[, paste0("answeroption_0", 1:5)])))
    n_if_answer <- sum(!is.na(unlist(x[, paste0("if_answeroption_0", 1:5)])))
    if(n_answer != n_if_answer) {
        cli::cli_alert_danger("Es wurden {n_answer} Felder für {.field answer_option} ausgefüllt, jedoch {n_if_answer} Felder für {.field if_answeroption}. Diese müssen identisch sein!")
        return(FALSE)
    } else {
        cli::cli_alert_success("Anzahl der Antwortmöglichkeiten entspricht der Anzahl an Feedbackblöcke.")
        return(TRUE)
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

validate_str <- function(x, var, valid, dist_len) {
    if(!x %in% valid) {
        str_dist <- stringdist::stringdist(valid, x, method = "lv")
        if(min(str_dist) < dist_len) {
            nearest_match <- which.min(str_dist)
            cli::cli_alert_danger(c("Invalide Eingabe für Variable {.field {var}}: {.arg {x}}.", "Muss einer dieser Kategorien sein: {.arg {valid}}.", "Meintest du {.arg {valid[nearest_match]}}?"))
            return(FALSE)
        } else {
            cli::cli_alert_danger("Invalide Eingabe für Variable {.field {var}}: {.arg {x}}. Muss einer dieser Kategorien sein: {.arg {valid}}")
            return(FALSE)
        }
    } else {
        cli::cli_alert_success("Eingabe für Variable {.field {var}} korrekt.")
        return(TRUE)
    }
}


validate_input <- function(filename) {
    x <- parse_md_to_csv(filename)
    v1 <- validate_id_item(x$id_item)
    v2 <- vector(mode = "list", length = length(names(valid_names)))
    names(v2) <- names(valid_names)
    for(nm in names(valid_names)) {
        v2[[nm]] <- validate_str(x = unlist(x[, nm]), var = nm, valid = valid_names[[nm]], dist_len = 5)
    }
    v3 <- validate_stimulus_image(x)
    v4 <- validate_answeroption(x)
    v5 <- validate_answer_correct(x)
    v6 <- validate_if_answeroption(x)
    if(any(!unname(unlist(list(v1, v2, v3, v4, v5, v6))))) cli::cli_abort("Einige Anforderungen sind nicht erfüllt, bitte überprüfen die Meldungen")
}


