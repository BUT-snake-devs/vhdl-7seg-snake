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
           dp   : out STD_LOGIC);
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
        Port ( clk         : in STD_LOGIC;
               rst         : in STD_LOGIC;
               en_speed    : in STD_LOGIC;
               bite_itself : in STD_LOGIC;
               btn_press   : in STD_LOGIC;
               btn_data    : in STD_LOGIC_VECTOR (1 downto 0);
               x_pos       : out STD_LOGIC_VECTOR (3 downto 0);
               y_pos       : out STD_LOGIC_VECTOR (2 downto 0));
    end component;

     component tail is
         Port ( clk         : in STD_LOGIC;
                rst         : in STD_LOGIC;
                en_speed    : in STD_LOGIC;
                en_mux      : in STD_LOGIC;
                x_pos_i     : in STD_LOGIC_VECTOR (3 downto 0);
                y_pos_i     : in STD_LOGIC_VECTOR (2 downto 0);
                lenght      : in STD_LOGIC_VECTOR (5 downto 0);
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
             G_MAX => 300_000_000 -- 3 seconds at 100MHz
         )
         Port map (
             clk => clk,
             rst => btnc,
             ce  => sig_cnt_en
         );

    clk_speed_inst : clk_en
        Generic map (
            G_MAX => 100_000_000 -- 1 second at 100MHz
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
            clk         => clk,
            rst         => btnc,
            en_speed    => sig_en_speed,
            bite_itself => sig_bite_itself,
            btn_press   => sig_btn_press,
            btn_data    => sig_btn_data,
            x_pos       => sig_xpos_head_tail,
            y_pos       => sig_ypos_head_tail
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

    dp <= '1'; --! Decimal point is always off

end Behavioral;
