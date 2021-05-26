setws .
app create -name z7_fsbl -hw design_1_wrapper.xsa -os standalone -proc ps7_cortexa9_0 -template {Zynq FSBL}
app config -name z7_fsbl define-compiler-symbols {FSBL_DEBUG_INFO}
app build -name z7_fsbl

