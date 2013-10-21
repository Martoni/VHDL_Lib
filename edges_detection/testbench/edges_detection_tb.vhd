---------------------------------------------------------------------------
-- Company     :  Armadeus Systems
-- Author(s)   :  Fabien Marteau fabien.marteau@armadeus.com
--
-- Creation Date : 2013-10-17
-- File          : edges_detection_tb.vhd
--
-- Abstract :
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity edges_detection_tb is
end entity edges_detection_tb;

architecture RTL of edges_detection_tb is

    CONSTANT HALF_PERIODE : time := 5.26315789474 ns;  -- 95Mhz

    component edges_detection
        port ( clk   : in std_logic;
               reset : in std_logic;
               trig_inv : in std_logic;
               triggers_vector       : in  std_logic_vector(1 downto 0);
               triggers_vector_pulse : out std_logic_vector(1 downto 0));
    end component edges_detection;

    signal clk   : std_logic;
    signal reset : std_logic;
    signal triggers_vector : std_logic_vector(1 downto 0);
    signal triggers_vector_pulse : std_logic_vector(1 downto 0);

    signal trig_inv : std_logic;

begin

    edges_detection_con : edges_detection
    port map (
        clk   => clk,
        reset => reset,
        trig_inv => trig_inv,
        triggers_vector       => triggers_vector,
        triggers_vector_pulse => triggers_vector_pulse
    );

    stimulis : process
    begin
        reset <= '1';
        trig_inv <= '1';
        triggers_vector <= (others => '0');
        wait for 1.2 us;
        reset <= '0';
        wait for 0.8 us;

        trig_inv <= '1';
        triggers_vector <= "01";
        wait for 1.5 us;
        triggers_vector <= "11";
        wait for 1.7 us;
        triggers_vector <= "01";
        wait for 1.7 us;
        triggers_vector <= "11";
        wait for 1.7 us;
        triggers_vector <= "10";
        wait for 1.7 us;
        triggers_vector <= "00";
        wait for 1.7 us;
        triggers_vector <= "11";
        wait for 1.5 us;

        trig_inv <= '0';
        wait for 1.5 us;
        triggers_vector <= "01";
        wait for 1.5 us;
        triggers_vector <= "11";
        wait for 1.7 us;
        triggers_vector <= "01";
        wait for 1.7 us;
        triggers_vector <= "11";
        wait for 1.7 us;
        triggers_vector <= "10";
        wait for 1.7 us;
        triggers_vector <= "00";
        wait for 1.7 us;
        triggers_vector <= "11";


        wait for 5 us;
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
        report "Time "&integer'image(time_c)&" us";
        wait for 1 us;
        time_c := time_c + 1;
    end process time_count;

end architecture RTL;
