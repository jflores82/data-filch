# Data filch

A retro arcade action game inspired by a famous Atari 2600 game with the same initials.

Coded and built with [Pico-8](https://www.lexaloffle.com/pico-8.php)

## Plot

You play as a industrial spy from _NotGood_ _Inc_, tasked with infiltrating the buildings of _VeryEvil_ _Corp_ to 
steal their data and secrets. Their security systems are top of the line and literally cutting edge. 
Are you a bad enough spy to ~~rescue~~ steal the data? 

## ScreenShots
![Data Filch 01](https://classicgames.com.br/site/img/datafilch1.png) ![Data Filch 02](https://classicgames.com.br/site/img/datafilch2.png)
![Data Filch 03](https://classicgames.com.br/site/img/datafilch3.png) ![Data Filch 04](https://classicgames.com.br/site/img/datafilch4.png)


## Instructions

The game is divided into two screens: 

**Side-View Screen:**
Arrows Keys or D-Pad: Move Left / Right or Crouch.
Z / 1 - Jump

**Top-view Screen:**
Arrows Keys - Move in 8 directions. 

**Scoring:**
In the side view portion, you will be scored by going left, and lose points by backtracking, you can get a D (danger) multiplier, 
if you get really close to the enemy drones without dieing a horrible gory death.

In the top view portion, you will be score by collecting the floppy disks that VeryEvil Corp left laying around, which, 
let's face it, its very convenient for you. 

## Build Instructions

You need the paid version of [Pico-8](https://www.lexaloffle.com/pico-8.php) to compile / run the code.
Navigate to the root folder of the code and execute:

`pico8 -export datafilch.html` 

or you can open pico-8 and do: 

`load datafilch.p8`
`export datafilch.html`

you can replace "html" with "bin" to create native versions for your OS, for more information, please refer to the pico-8 manual.

## Releases 

Version 2 (20260203):
- Adjusted player hitbox to match player sprite instead of the whole tile.
- Changed game over screen to require a X button press, instead of a O button, preventing a mispress.
- Added high score routines, it saves to cart.
- Added option on the main menu to clear the current saved hiscore.

Version 1 (20260202):
- First Public Release

 
## License
This project is licensed under the **MIT License**, except where noted below.

- The **source code** is licensed under the [MIT License](LICENSE).
- The **assets** (images, sounds, etc.) are licensed under the  
  [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Contributor License Agreement (CLA)

By submitting a pull request, you agree that:
- Your contribution is your own original work.
- You grant the project maintainer(s) a perpetual, worldwide, non-exclusive license to use, reproduce, and distribute your contribution under the project's existing license (MIT).
- You understand that your contribution will be made publicly available as part of the project.

## Disclaimer
The software is provided “as is”, without any warranty.  
The author shall not be held responsible for any damages, misuse, or modifications of the code or assets.



