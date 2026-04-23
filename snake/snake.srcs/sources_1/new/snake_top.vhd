library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity snake_top is
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnr : in STD_LOGIC;
           an   : out STD_LOGIC_VECTOR (7 downto 0);
           seg  : out STD_LOGIC_VECTOR (6 downto 0);
           dp   : out STD_LOGIC;
           led17_g : out STD_LOGIC;  -- Green LED for alive state
           led16_r : out STD_LOGIC   -- Red LED for dead state
           );
end snake_top;
---------------------------------------------------------
architecture Behavioral of snake_top is

    component btn_ctrl is
        generic (
            DEBOUNCE_MAX : integer := 2
        );
        Port ( clk       : in STD_LOGIC;
               rst       : in STD_LOGIC;
               btnu      : in STD_LOGIC;
               btnl      : in STD_LOGIC;
               btnd      : in STD_LOGIC;
               btnr      : in STD_LOGIC;
               btn_press : out STD_LOGIC;
               btn_data  : out STD_LOGIC_VECTOR (1 downto 0));
    end component;

    component clk_en is
        Generic (
            G_MAX : positive := 25_000_000  -- Default number of clock cycles
        );
        Port ( clk : in  STD_LOGIC;
               rst : in  STD_LOGIC;
               ce  : out STD_LOGIC);
    end component;

    component counter is
        generic (
            G_BITS : positive := 4  --! Default number of bits
        );
        port (
            clk : in  std_logic;                             --! Main clock
            rst : in  std_logic;                             --! High-active synchronous reset
            en  : in  std_logic;                             --! Clock enable input
            cnt : out std_logic_vector(G_BITS - 1 downto 0)  --! Counter value
        );
    end component;

    component head is
        Port ( clk          : in STD_LOGIC;
               rst          : in STD_LOGIC;
               en_speed     : in STD_LOGIC;
               bite_itself  : in STD_LOGIC;
               btn_press    : in STD_LOGIC;
               btn_data     : in STD_LOGIC_VECTOR (1 downto 0);
               x_pos        : out STD_LOGIC_VECTOR (3 downto 0);
               y_pos        : out STD_LOGIC_VECTOR (2 downto 0);
               game_state_o : out STD_LOGIC  -- Output signal to indicate if the snake is alive (1) or dead (0)
               );
    end component;

     component tail is
         Port ( clk         : in STD_LOGIC;
                rst         : in STD_LOGIC;
                en_speed    : in STD_LOGIC;
                en_mux      : in STD_LOGIC;
                x_pos_i     : in STD_LOGIC_VECTOR (3 downto 0);
                y_pos_i     : in STD_LOGIC_VECTOR (2 downto 0);
                lenght      : in STD_LOGIC_VECTOR (5 downto 0);
                game_state  : in  STD_LOGIC;
                x_pos_o     : out STD_LOGIC_VECTOR (3 downto 0);
                y_pos_o     : out STD_LOGIC_VECTOR (2 downto 0);
                bite_itself : out STD_LOGIC);
     end component;

    component display is
        Port ( clk    : in STD_LOGIC;
               rst    : in STD_LOGIC;
               x_pos  : in STD_LOGIC_VECTOR (3 downto 0);
               y_pos  : in STD_LOGIC_VECTOR (2 downto 0);
               an     : out STD_LOGIC_VECTOR (7 downto 0);
               seg    : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    component game_state_led is
        Port ( clk          : in STD_LOGIC;
               rst          : in STD_LOGIC;
               game_state_i : in STD_LOGIC;  -- Input signal indicating if the snake is alive (1) or dead (0)
               led17_g      : out STD_LOGIC;
               led16_r      : out STD_LOGIC
               );
    end component;

    signal sig_btn_press         : STD_LOGIC;
    signal sig_btn_data          : STD_LOGIC_VECTOR (1 downto 0);
    signal sig_cnt_en            : STD_LOGIC;
    signal sig_en_speed          : STD_LOGIC;
    signal sig_en_mux            : STD_LOGIC;
    signal sig_cnt_val           : STD_LOGIC_VECTOR (5 downto 0);
    signal sig_xpos_head_tail    : STD_LOGIC_VECTOR (3 downto 0);
    signal sig_ypos_head_tail    : STD_LOGIC_VECTOR (2 downto 0);
    signal sig_xpos_tail_display : STD_LOGIC_VECTOR (3 downto 0);
    signal sig_ypos_tail_display : STD_LOGIC_VECTOR (2 downto 0);
    signal sig_bite_itself       : STD_LOGIC;
    signal sig_game_state        : STD_LOGIC;  -- Signal to hold the current game state (alive or dead)

begin

    btn_ctrl_inst : btn_ctrl
        Port map (
            clk       => clk,
            rst       => btnc,
            btnu      => btnu,
            btnl      => btnl,
            btnd      => btnd,
            btnr      => btnr,
            btn_press => sig_btn_press,
            btn_data  => sig_btn_data
        );

     clk_lenght_inst : clk_en
         Generic map (
             G_MAX => 100_000_000 -- 1 seconds at 100MHz
         )
         Port map (
             clk => clk,
             rst => btnc,
             ce  => sig_cnt_en
         );

    clk_speed_inst : clk_en
        Generic map (
            G_MAX => 50_000_000 -- 0.5 second at 100MHz
        )
        Port map (
            clk => clk,
            rst => btnc,
            ce  => sig_en_speed
        );

    clk_mux_inst : clk_en
        Generic map (
            G_MAX => 100_000 -- 1 millisecond at 100MHz
        )
        Port map (
            clk => clk,
            rst => btnc,
            ce  => sig_en_mux
        );
    
     counter_inst : counter
         Generic map (
             G_BITS => 6
         )
         Port map (
             clk => clk,
             rst => btnc,
             en  => sig_cnt_en,
             cnt => sig_cnt_val
         );

    head_inst : head
        Port map (
            clk          => clk,
            rst          => btnc,
            en_speed     => sig_en_speed,
            bite_itself  => sig_bite_itself,
            btn_press    => sig_btn_press,
            btn_data     => sig_btn_data,
            x_pos        => sig_xpos_head_tail,
            y_pos        => sig_ypos_head_tail,
            game_state_o => sig_game_state
        );

     tail_inst : tail
         Port map (
             clk         => clk,
             rst         => btnc,
             en_speed    => sig_en_speed,
             en_mux      => sig_en_mux,
             x_pos_i     => sig_xpos_head_tail,
             y_pos_i     => sig_ypos_head_tail,
             lenght      => sig_cnt_val,
             game_state  => sig_game_state,
             x_pos_o     => sig_xpos_tail_display,
             y_pos_o     => sig_ypos_tail_display,
             bite_itself => sig_bite_itself
         );

    display_inst : display
        Port map (
            clk    => clk,
            rst    => btnc,
            x_pos  => sig_xpos_tail_display,
            y_pos  => sig_ypos_tail_display,
            an     => an,
            seg    => seg
        );

    game_state_led_inst : game_state_led
        Port map (
            clk          => clk,
            rst          => btnc,
            game_state_i => sig_game_state,
            led17_g      => led17_g,
            led16_r      => led16_r
        );

    dp <= '1'; --! Decimal point is always off

end Behavioral;
