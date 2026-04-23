library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity btn_ctrl is
    generic (
        DEBOUNCE_MAX : integer := 2
    );
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        btnu      : in  STD_LOGIC;
        btnl      : in  STD_LOGIC;
        btnd      : in  STD_LOGIC;
        btnr      : in  STD_LOGIC;
        btn_press : out STD_LOGIC;
        btn_data  : out STD_LOGIC_VECTOR(1 downto 0)
    );
end btn_ctrl;

architecture Behavioral of btn_ctrl is
    signal btns_raw         : std_logic_vector(3 downto 0);
    signal btns_sync1       : std_logic_vector(3 downto 0) := (others => '0');
    signal btns_sync2       : std_logic_vector(3 downto 0) := (others => '0');
    signal btns_stable      : std_logic_vector(3 downto 0) := (others => '0');
    signal btns_stable_prev : std_logic_vector(3 downto 0) := (others => '0');

    signal cnt_u : integer range 0 to DEBOUNCE_MAX := 0;
    signal cnt_l : integer range 0 to DEBOUNCE_MAX := 0;
    signal cnt_d : integer range 0 to DEBOUNCE_MAX := 0;
    signal cnt_r : integer range 0 to DEBOUNCE_MAX := 0;

    signal btn_press_r : std_logic := '0';
    signal btn_data_r  : std_logic_vector(1 downto 0) := "00";
begin
    btns_raw <= btnu & btnl & btnd & btnr;

    btn_press <= btn_press_r;
    btn_data  <= btn_data_r;

    process(clk)
        variable stable_next : std_logic_vector(3 downto 0);
        variable new_press   : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                btns_sync1       <= (others => '0');
                btns_sync2       <= (others => '0');
                btns_stable      <= (others => '0');
                btns_stable_prev <= (others => '0');
                cnt_u            <= 0;
                cnt_l            <= 0;
                cnt_d            <= 0;
                cnt_r            <= 0;
                btn_press_r      <= '0';
                btn_data_r       <= "00";
            else
                btns_sync1 <= btns_raw;
                btns_sync2 <= btns_sync1;

                stable_next := btns_stable;

                if btns_sync2(3) = btns_stable(3) then
                    cnt_u <= 0;
                elsif cnt_u = DEBOUNCE_MAX then
                    stable_next(3) := btns_sync2(3);
                    cnt_u <= 0;
                else
                    cnt_u <= cnt_u + 1;
                end if;

                if btns_sync2(2) = btns_stable(2) then
                    cnt_l <= 0;
                elsif cnt_l = DEBOUNCE_MAX then
                    stable_next(2) := btns_sync2(2);
                    cnt_l <= 0;
                else
                    cnt_l <= cnt_l + 1;
                end if;

                if btns_sync2(1) = btns_stable(1) then
                    cnt_d <= 0;
                elsif cnt_d = DEBOUNCE_MAX then
                    stable_next(1) := btns_sync2(1);
                    cnt_d <= 0;
                else
                    cnt_d <= cnt_d + 1;
                end if;

                if btns_sync2(0) = btns_stable(0) then
                    cnt_r <= 0;
                elsif cnt_r = DEBOUNCE_MAX then
                    stable_next(0) := btns_sync2(0);
                    cnt_r <= 0;
                else
                    cnt_r <= cnt_r + 1;
                end if;

                btns_stable <= stable_next;

                btn_press_r <= '0';
                new_press := stable_next and not btns_stable_prev;

                if new_press /= "0000" then
                    btn_press_r <= '1';
                    if new_press(3) = '1' then
                        btn_data_r <= "00";
                    elsif new_press(2) = '1' then
                        btn_data_r <= "01";
                    elsif new_press(1) = '1' then
                        btn_data_r <= "10";
                    else
                        btn_data_r <= "11";
                    end if;
                end if;

                btns_stable_prev <= stable_next;
            end if;
        end if;
    end process;
end Behavioral;
