file(READ "${X265_PC_PATH}" pc_content)
string(REGEX MATCH "Libs\\.private: ([^\n]*)" _ "${pc_content}")
set(PRIVATE_LIBS "${CMAKE_MATCH_1}")
string(REGEX REPLACE
    "Libs:([^\n]*)"
    "Libs:\\1 ${PRIVATE_LIBS}"
    pc_content "${pc_content}"
)
file(WRITE "${X265_PC_PATH}" "${pc_content}")