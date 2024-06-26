extends Resource
class_name CinematicFrame

## La imagen que se va a mostrar para este frame de la cinemática.
## El tamaño máximo es de 288x162.
@export var frame : Texture2D
## El texto que se muestra en la parte inferior de la cinamática.
@export_multiline var text : String
