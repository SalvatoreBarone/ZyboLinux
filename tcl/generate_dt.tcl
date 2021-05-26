hsi::open_hw_design design_1_wrapper.xsa
hsi::set_repo_path device-tree-xlnx
hsi::create_sw_design device_tree -os device_tree -proc ps7_cortexa9_0
hsi::generate_target -dir custom_dt
