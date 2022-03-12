onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_toplevel/err
add wave -noupdate /tb_toplevel/TB_SW
add wave -noupdate /tb_toplevel/TB_KEY
add wave -noupdate /tb_toplevel/TB_LEDR
add wave -noupdate /tb_toplevel/TB_HEX0
add wave -noupdate /tb_toplevel/TB_HEX1
add wave -noupdate /tb_toplevel/TB_HEX2
add wave -noupdate /tb_toplevel/TB_HEX3
add wave -noupdate /tb_toplevel/TB_HEX4
add wave -noupdate /tb_toplevel/TB_HEX5
add wave -noupdate /tb_toplevel/TB_CLK
add wave -noupdate /tb_toplevel/TB_RESET
add wave -noupdate /tb_toplevel/EXPECTED_LEDR
add wave -noupdate /tb_toplevel/OLD_HEX0
add wave -noupdate /tb_toplevel/OLD_HEX1
add wave -noupdate /tb_toplevel/OLD_HEX2
add wave -noupdate /tb_toplevel/OLD_HEX3
add wave -noupdate /tb_toplevel/OLD_HEX4
add wave -noupdate /tb_toplevel/OLD_HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {295 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 313
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1187 ps}
