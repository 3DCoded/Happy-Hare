| Field                   |   Type   | Description                                                  |
| ----------------------- | :------: | ------------------------------------------------------------ |
| `size`                  |   int    | The gcode file size in bytes.                                |
| `modified`              |  float   | The last modified time in Unix Time (seconds).               |
| `uuid`                  |  string  | A unique identifier for the metadata object.                 |
| `slicer`                |  string  | The name of the slicer software used to slice the file.      |
| `slicer_version`        |  string  | The version of the slicer software.                          |
| `gcode_start_byte`      |   int    | The byte offset in the file where the first gcode command    |
| `gcode_int_byte`        |   int    | The byte offset in the file where the last gcode command     |
| `object_height`         |  float   | The height (in mm) of the tallest object in the file.        |
| `estimated_time`        |  float   | The estimated time to complete the print, in seconds.        |
| `nozzle_diameter`       |  float   | The configured nozzle diameter, in mm.                       |
| `layer_height`          |  float   | The configured layer height, in mm.                          |
| `first_layer_height`    |  float   | The configured first layer height in mm.                     |
| `first_layer_extr_temp` |  float   | The configured first layer extruder temperature, in Celsius. |
| `first_layer_bed_temp`  |  float   | The configured first layer bed temperature, in Celsius.      |
| `chamber_temp`          |  float   | The configured chamber temperature, in Celsius.              |
| `filament_name`         |   str    | The name(s) of the filament used.                            |
| `filament_color`        |   str    | The colors(s) of the filament used in #RRGGBB format.        |
| `extruder_color`        |   str    | The slicer defined extruder color(s) for the print.          |
| `filament_temp`         |   str    | The base temperature(s) of filament used, in Celsius.        |
| `filament_type`         |   str    | The type(s) of filament used, ie: `PLA`.                     |
| `filament_total`        |  float   | The total length filament used in mm.                        |
| `filament_weight_total` |  float   | The total weight of filament used in grams.                  |
| `single_extruder_multi_material` | int | Identifies a multimaterial print with single extruder.   |
| `referenced_tools`      |  string  | Comma separated list of a tool numbers used in the print.    |
| `thumbnails`            | [object] | A list of `Thumbnail Info` objects.                          |


