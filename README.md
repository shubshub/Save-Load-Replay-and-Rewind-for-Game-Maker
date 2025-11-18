Documentation - Very Simple to use

Import the Package into your Game
Drop the obj_rewind_controller and obj_saveload_controller into your First Game Room

Otherwise you can called LoadGame2() and set global.game_started to true however you like

THIS LIBRARY WILL LIKELY WORK BEST IF YOUR GAME FULLY TAKES PLACE INSIDE THE ROOM THAT THE CONTROLLERS ARE IN

Give all objects that are subject to saving and rewinding the "saveable" tag


To Save, Press Space
To Load, Press L
To Rewind, Press R

You can configure stuff about the Rewind Controller in the Create Event of the obj_rewind_controller global.CONFIGS

To prevent things from executing in your regular objects while you are rewinding, you can check the global.isRewinding function to see if rewinding is true

There are some notable bugs with Loading, That I plan to fix in a future release
