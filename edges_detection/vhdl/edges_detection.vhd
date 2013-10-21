--
-- Copyright (c) ARMadeus Project 2013
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2, or (at your option)
-- any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
--*********************************************************************
--
-- File          : edges_detection.vhd
-- Created on    : 21/10/2013
-- Author        : Fabien Marteau <fabien.marteau@armadeus.com>
--
--*********************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

Entity edges_detection is
    port (
        clk : in std_logic;
        reset : in std_logic;
        trig_inv : in std_logic;
        triggers_vector       : in  std_logic_vector(1 downto 0);
        triggers_vector_pulse : out std_logic_vector(1 downto 0)
    );
end entity;

Architecture edges_detection_1 of edges_detection is

    signal triggers_vector_old : std_logic_vector(1 downto 0);

begin

   -- detect edge on trigger[]
    triggers_pulse_p : process(clk, reset)
    begin
        if reset = '1' then
            triggers_vector_pulse <= (others => '0');
            triggers_vector_old   <= triggers_vector;
        elsif rising_edge(clk) then
            if trig_inv = '1' then -- pulse on falling edges
                triggers_vector_pulse <=
                    (triggers_vector_old xor triggers_vector)
                        and triggers_vector_old;
            else -- pulse on rising_edge
                triggers_vector_pulse <=
                    (triggers_vector_old xor triggers_vector)
                        and triggers_vector;
            end if;
            triggers_vector_old   <= triggers_vector;
        end if;
    end process triggers_pulse_p;

end architecture edges_detection_1;

