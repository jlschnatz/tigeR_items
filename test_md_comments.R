
#' @title Remove Markdown Comments in String via Regular Expressions
#' @param x A character string.
#' @return A character string without markdown comments.
rm_md_comments <- function(x) {
    rgx <- "<![-]{2,3}(.|\\s|\\r)*?[-]{2,3}>"
    gsub(pattern = rgx, replacement = "", x)
}

# Sample Markdown text with various comments
x <- "
# Title of the Document

This is the introduction paragraph.

<!--- 
This is a multi-line comment
spanning multiple lines.
-->

Here is a list of items:
- Item 1
<!-- Comment for Item 1 -->
- Item 2
<!--- This is another multi-line comment
that describes Item 2 
in detail. --->

# Section Two

This section talks about important details.

<!-- 
An inline comment about the section 
-->
Some important content here.

# Final Thoughts

<!-- A single-line comment -->

And finally, a closing remark.

<!---  Final multi-line comment 
which is not really needed
but is present just for testing purposes
--->
"

cat(rm_md_comments(x))

