---------------------------------------------------------------------------
-- Company     :  Armadeus Systems
-- Author(s)   :  Fabien Marteau fabien.marteau@armadeus.com
--
-- Creation Date : 2013-10-17
-- File          : debounce_tb.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity debounce_tb is
end entity debounce_tb;

architecture RTL of debounce_tb is

    CONSTANT HALF_PERIODE : time := 5.26315789474 ns;  -- 95Mhz

    component debounce is
        generic ( clk_freq    : natural := 95_000_000;
                  deb_time_ms : natural := 20);
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            input : in  std_logic;
            output: out std_logic
        );
    end component;

    signal clk   : std_logic;
    signal reset : std_logic;
    signal buttons_in  : std_logic;
    signal buttons_out : std_logic;

begin

    debounce_con : debounce
    generic map(
        clk_freq   => 95_000_000,
        deb_time_ms => 20)
    port map(
        clk    => clk,
        reset  => reset,
        input  => buttons_in,
        output => buttons_out
    );

    stimulis : process
    begin
        reset <= '1';
        buttons_in <= '1';
        wait for 1.2 us;
        reset <= '0';

        -- button 0 bounce
        wait for 1.7 ms;
        buttons_in <= '0';
        wait for 1.3 ms;
        buttons_in <= '1';
        wait for 1 ms;
        buttons_in <= '0';
        wait for 0.8 ms;
        buttons_in <= '1';
        wait for 0.6 ms;
        buttons_in <= '0';
        wait for 1.7 ms;
        buttons_in <= '0';
        wait for 1.3 ms;
        buttons_in <= '1';
        wait for 1 ms;
        buttons_in <= '0';
        wait for 0.8 ms;
        buttons_in <= '1';
        wait for 0.6 ms;
        buttons_in <= '0';

        wait for 11 ms;

        buttons_in <= '1';
        wait for 1.7 ms;
        buttons_in <= '0';
        wait for 1.3 ms;
        buttons_in <= '1';
        wait for 1 ms;
        buttons_in <= '0';
        wait for 0.8 ms;
        buttons_in <= '1';
        wait for 0.6 ms;
        buttons_in <= '0';
        wait for 1.7 ms;
        buttons_in <= '0';
        wait for 1.3 ms;
        buttons_in <= '1';
        wait for 1 ms;
        buttons_in <= '0';
        wait for 0.8 ms;
        buttons_in <= '1';
        wait for 0.8 ms;
        buttons_in <= '0';


        wait for 50 ms;
        assert false report "*** End of test ***" severity error;
    end process stimulis;

    clockp : process
    begin
        clk <= '1';
        wait for HALF_PERIODE;
        clk <= '0';
        wait for HALF_PERIODE;
    end process clockp;

    -- time counter
    time_count : process
        variable time_c : natural := 0;
    begin
        report "Time "&integer'image(time_c)&" ms";
        wait for 1 ms;
        time_c := time_c + 1;
    end process time_count;

end architecture RTL;
