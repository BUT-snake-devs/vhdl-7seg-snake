
---

   # - VHDL 7-Segment Snake -
---


<pre>                  
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡉⠙⣻⣷⣶⣤⣀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡿⠋⠀⠀⠀⠀⢹⣿⣿⡟⠉⠉⠉⢻⡿⠀⠀⠀    University team project:
⠀⠀⠀⠀⠀⠀⠀⠰⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⣇⠀⠀⠀⠈⠇⠀⠀⠀        Snake game logic written
⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠉⠛⠿⣷⣤⡤.⠀⠀⠀⠀⠀     in VHDL using a 7-segment
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣶⣦⣤⣤⣀⣀⣀.⡀⠉⠀⠀⠀⠀⠀⠀      display output.
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀
⠀⠀⠀⢀⣀⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀   
⠀⠀⣰⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣧  ⠀   Language: VHDL
⠀⠀⣿⣿⣿⠁⠀⠈⠙⢿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⠀⠀    Development Environment: Vivado / VS Code   
⠀⠀⢿⣿⣿⣆⠀⠀⠀⠀⠈⠛⠿⣿⣶⣦⡤⠴⠀⠀⠀⠀⠀⣸⣿⣿⣿⡿⠀⠀    Target Board:  Nexys A7-50T 
⠀⠀⠈⢿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠃⠀⠀        
⠀⠀⠀⠀⠙⢿⣿⣿⣿⣶⣦⣤⣀⣀⡀⠀⠀⠀⣀⣠⣴⣾⣿⣿⣿⡿⠃⠀⠀⠀       
⠀⠀⠀⠀⠀⠀⠈⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀   VUT Brno University of Technology 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀      
⠀
</pre>
---
## Team Members :
* [Balaniuk Artem](https://github.com/artembal27104-beep)
* [Dulesov Gleb](https://github.com/glebdulesov-alt)
* [Matros Tymofii](https://github.com/Tymofii-Matros)
* [Yeriemieiev Daniil](https://github.com/daniil-yeriemieiev)
---
> [!IMPORTANT]
> ### Our Goal :
> Implementation of the classic Snake game logic using VHDL on the Nexys A7-50T. The game uses 8-digit 7-segment displays as play field

---

## Base Functions :
* **Movement Control:** (BTNU, BTND, BTNL, BTNR) Buttons to control snake
* **Reset:** (BTNC) Central button to restart the game
* **Scoring:** The snake grows in length as time passes, tracked by counter
* **Collision Detection/Game End:** Game ends when: Snake bites own tail or borders outside map
---
## Schematic:
![schema](images/schema.jpg)

---

## Design Description :

### 1. Button Control (`btn_ctrl`)
> [!NOTE]
> About : Providing physical button inputs to the game logic

| Port | Direction | Type | Description |
| :---: | :---: | :---: | :---: |
| `clk` | in | `std_logic` | Global clock  |
|`rst` | in | `std_logic` | Global reset |
| `btnu`, `btnl`, `btnd`, `btnr` | in | `std_logic` | Directional buttons |
| `btn_press` | out | `std_logic` | Trigger of press of any direction button |
| `btn_data(1:0)` | out | `std_logic_vector` | Direction data (Up, Down, Left, Right) |
---
### 2. Clock Domains (`clk_en`)

 > [!NOTE]
 > About : The main clock divided to 3 domains using `clk_en` modules
####  Display Multiplexing
| Parameter | Target Signal | Frequency | Role |
| :---: | :---: | :---: | :---: |
| `G_BITS=100_000` | `en_mux` | 1 ms | Switch between 8 anodes for dynamic 7-seg display  |

#### Snake Movement Speed
| Parameter | Target Signal | Frequency | Role |
| :---: | :---: | :---: | :---: |
| `G_BITS=200_000_000` | `sig_en_speed` | 2 s| Update snake's head coordinates |

#### Length & Score Timer
| Parameter | Target Signal | Frequency | Role |
| :---: | :---: | :---: | :---: |
| `G_BITS=300_000_000` | `sig_cnt_en` |3 s| Update counter to increase snake length |

>[!TIP] 
> every of them have `in` ports `clk` and `rst`, and `out` ports `ce`
---
### 3. Snake Head (`head`)
> [!NOTE]
> About : Calculate XY coordinates of snake's head based on it's direction
| Port name | Direction | Type | Description |
| --- | --- | --- | --- |
| `clk` | in | `std_logic` | Global clock |
| `rst` | in | `std_logic` | Global reset |
| `en_speed` | in | `std_logic` | Movement speed |
| `btn_data(1:0)`| in | `std_logic_vector` | Direction input
| `bite_itself` | in | `std_logic` | End signal |
| `x_pos(3:0)` | out | `std_logic_vector` | X coordinate |
| `y_pos(2:0)` | out | `std_logic_vector` | Y coordinate |
---
### 4. Snake Tail (`tail`)
> [!NOTE]
> About : Copy head and checks for self-collision
| Port name | Direction | Type | Description |
| --- | --- | --- | --- |
| `clk` | in | `std_logic` | Global clock |
| `rst` | in | `std_logic` | Global reset |
| `en_speed` | in | `std_logic` | Update position |
| `x_pos` | in | `std_logic_vector` | Coordinates of head|
| `y_pos`| in | `std_logic_vector` | Coordinates of head|
| `lenght(7:0)` | in | `std_logic_vector` | Current lenght|
| `bite_itself` | out | `std_logic` | End signal |

>[!TIP]
> `bite_itself` - works if head/tail cordinates match tail/head cordinates 
---
### 5. Counter (`counter`)
> [!NOTE]
> About : Calculate current length of snake

| Port name | Direction | Type | Description |
| --- | --- | --- | --- |
| `clk` | in | `std_logic` | Global clock |
| `rst` | in | `std_logic` | Global reset |
| `en` | in | `std_logic` | Lenght clock |
| `cnt(G_BITS-1:0)`| out | `std_logic_vector` | Length value |
---
### 6. Display Driver (`display`)
> [!NOTE]
> About : Visualize the snake's position
| Port name | Direction | Type | Description |
| --- | --- | --- | --- |
| `clk` | in | `std_logic` | Global clock |
| `rst` | in | `std_logic` | Global reset |
| `x_pos` | in | `std_logic_vector` | Coordinates|
| `y_pos`| in | `std_logic_vector` | Coordinates|
| `an(7:0)` | out | `std_logic_vector` | Digit selection |
| `seg(6:0)` | out | `std_logic_vector` | Segment selection |

---
---
---

<pre> 
⠀⠀                                Thanks for the visit!


        ⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣿⣿⣿⣿⣿⣷⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⡿⠿⢿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠞⠋⠉⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣷⣄⠀⠀⠀⠀⠀
        ⠀⠀⠀⣠⣾⣿⣿⣿⣿⠿⠛⠉⠁⠀⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣷⣄⠀⠀⠀
        ⠀⠀⣼⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣷⡀⠀⠀⠀⢀⣶⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣧⠀⠀
        ⠀⣼⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣄⠀⠀⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣧⠀
        ⢸⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⢂⣾⣿⣿⣿⠿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡄
        ⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡿⢡⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⡇
        ⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣱⣿⣿⣿⡿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡇
        ⢿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡟⣴⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⡇
        ⠸⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⠏⢸⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⠁
        ⠀⢻⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⡿⠃⠀⠀⠹⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⠃⠀
        ⠀⠀⠹⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⠟⠁⠀⠀⠀⠀⠈⢻⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⡿⠃⠀⠀
        ⠀⠀⠀⠈⠻⣿⣿⣿⣿⣶⣤⣀⣀⠀⠀⠀⣀⣀⣤⣶⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣶⣤⣀⣀⠀⠀⠀⢀⣀⣤⣶⣿⣿⣿⣿⠟⠁⠀⠀⠀
        ⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⠿⠿⠿⠿⠿⠟⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⣿⠿⠿⠟⠋⠁⠀⠀⠀⠀
        ⠀⠀⠀⠀
</pre>