library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tail is
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
end tail;

architecture Behavioral of tail is

    constant SNAKE_MAX_LEN : integer := 64;

    type arr_x_t is array (0 to SNAKE_MAX_LEN-1) of STD_LOGIC_VECTOR(3 downto 0);
    type arr_y_t is array (0 to SNAKE_MAX_LEN-1) of STD_LOGIC_VECTOR(2 downto 0);

    signal snake_x : arr_x_t := (others => (others => '0'));
    signal snake_y : arr_y_t := (others => (others => '0'));

    signal mux_idx  : integer range 0 to SNAKE_MAX_LEN-1 := 0;
    signal bite_reg : STD_LOGIC := '0';

    function clamp_length(len_slv : STD_LOGIC_VECTOR(7 downto 0)) return integer is
        variable tmp : integer;
    begin
        tmp := to_integer(unsigned(len_slv));

        if tmp < 1 then
            return 1;
        elsif tmp > SNAKE_MAX_LEN then
            return SNAKE_MAX_LEN;
        else
            return tmp;
        end if;
    end function;

begin

    --------------------------------------------------------------------
    -- Tail memory + self-collision check
    --------------------------------------------------------------------
    p_tail_move : process(clk)
        variable len_int   : integer;
        variable collision : STD_LOGIC;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Начальное состояние хвоста
                -- Согласуй с reset-позицией в head
                snake_x(0) <= "0011"; -- x = 3
                snake_y(0) <= "001";  -- y = 1

                snake_x(1) <= "0100"; -- x = 4
                snake_y(1) <= "001";  -- y = 1

                snake_x(2) <= "0101"; -- x = 5
                snake_y(2) <= "001";  -- y = 1

                for i in 3 to SNAKE_MAX_LEN-1 loop
                    snake_x(i) <= (others => '0');
                    snake_y(i) <= (others => '0');
                end loop;

                bite_reg <= '0';

            elsif en_speed = '1' then
                len_int := clamp_length(lenght);

                -- Проверка укуса себя:
                -- новая голова x_pos_i/y_pos_i сравнивается с активным телом
                collision := '0';
                for i in 1 to len_int-1 loop
                    if (x_pos_i = snake_x(i)) and (y_pos_i = snake_y(i)) then
                        collision := '1';
                    end if;
                end loop;

                bite_reg <= collision;

                -- Если не врезались в себя, обновляем хвост
                if collision = '0' then
                    -- Сдвиг тела от хвоста к голове
                    for i in SNAKE_MAX_LEN-1 downto 1 loop
                        snake_x(i) <= snake_x(i-1);
                        snake_y(i) <= snake_y(i-1);
                    end loop;

                    -- Запись новой головы в нулевой элемент
                    snake_x(0) <= x_pos_i;
                    snake_y(0) <= y_pos_i;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Multiplex index for sequential tail output
    --------------------------------------------------------------------
    p_mux_idx : process(clk)
        variable len_int : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                mux_idx <= 0;

            elsif en_mux = '1' then
                len_int := clamp_length(lenght);

                if mux_idx >= len_int - 1 then
                    mux_idx <= 0;
                else
                    mux_idx <= mux_idx + 1;
                end if;
end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Outputs
    --------------------------------------------------------------------
    x_pos_o <= snake_x(mux_idx);
    y_pos_o <= snake_y(mux_idx);

    bite_itself <= bite_reg;

end Behavioral;