#' Clean CSB geo to SF object
#'
#' @description \code{csb_projectXY} converts SRX and SRY data into a simple features object. You can write a shapefile directly from the output of this function using sf::st_write
#'
#' @usage csb_projectXY(.data, varX, varY, crs = NULL)
#'
#' @param .data A tibble with raw CSB data
#' @param varX name of column containing SRX data
#' @param varY name of column containing SRY data
#' @param crs coordinate reference system for the data to be projected into
#'
#' @return \code{csb_projectXY} returns a sf object of the input data, specifying a new crs will reproject the data.
#'
#' @importFrom sf st_as_sf st_transform
#' @importFrom rlang quo enquo sym :=
#'
#' @examples
#' #You MUST remove observations with missing coordinates before using this function
#' csb <- csb_missingXY(january_2018, SRX, SRX, filter = TRUE)
#' csb_projectXY(csb, SRX, SRY)
#' csb_projectXY(csb, SRX, SRY, crs = 4269)
#'
#' @export
csb_projectXY <- function(.data, varX, varY, crs = NULL){
### Check input and Non-Standard evaluation
  ## check for missing parameters of required arguments
  if (missing(.data)) {
    stop('Please provide an argument for .data')
  }
  if (missing(varX)) {
    stop('Please provide an argument for varX')
  }
  if (missing(varY)) {
    stop('Please provide an argument for varY')
  }
  ## NSE setup
  varXN <- rlang::quo_name(rlang::enquo(varX))
  varYN <- rlang::quo_name(rlang::enquo(varY))

  ## Check for invalid spatial data, which will error in the sf function
  if(anyNA(.data[,varXN])){stop('Please use the csb_missing with filter = TRUE to remove invalid spatial data before using this function.')}

  # based on testing, I believe the CSB data to include US Survey feets coordinates by default
  # Which is EPSG = 102696

  sf::st_as_sf(.data, coords = c(x = varXN, y = varYN), crs = 102696) -> sfobj

 # Reproject

 if(!is.null(crs)){sf::st_transform(sfobj, crs = crs) -> sfobj}

 # return the sf object

  return(sfobj)
}