--
-- Copyright (c) Armadeus project 2013
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
-- File          : debounce.vhd
-- Created on    : 17/10/2013
-- Author        : Fabien Marteau <fabien.marteau@armadeus.com>
--
--*********************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

Entity debounce is
    generic ( clk_freq : natural := 95_000_000;
              deb_time_ms : natural := 20);
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        input : in  std_logic;
        output: out std_logic
    );
end entity;

Architecture debounce_1 of debounce is
    signal input_old : std_logic;
    signal edge : std_logic;
    signal output_s : std_logic;
    CONSTANT MAX_COUNT : natural := (clk_freq * deb_time_ms/1000)+1;

    signal count : natural range 0 to MAX_COUNT;

begin

    edge_pc: process(clk, reset)
    begin
        if (reset = '1') then
            input_old <= input;
        elsif rising_edge(clk) then
            edge <= input xor input_old; 
            input_old <= input;
        end if;
    end process edge_pc;

    -- counter
    count_p : process(clk, reset)
    begin
        if reset = '1' then
            count <= (MAX_COUNT - 1);
        elsif rising_edge(clk) then
            if count /= (MAX_COUNT - 1) then
                count <= count + 1;
            elsif edge = '1' then
                count <= 0;
            end if;
        end if;
    end process count_p;

    -- update output value
    output_s <= input when count = (MAX_COUNT - 1) else output_s;
    output <= output_s;

end architecture debounce_1;

