#
# Copyright 2018, Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

include(${SRC_DIR}/helpers.cmake)

function(test)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool10)

	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool11)

	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool12)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool12)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool12)

	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool13)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool13)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool13)

	# 1.0 -> 1.1
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.0 --to=1.1 ${DIR}/pool10 -X fail-safety)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool10)

	# 1.1 -> 1.2
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.1 --to=1.2 ${DIR}/pool10 -X fail-safety -X 1.2-pmemmutex)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool10)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool10)

	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.1 --to=1.2 ${DIR}/pool11 -X fail-safety -X 1.2-pmemmutex)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool11)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool11)

	# 1.2 -> 1.3
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.2 --to=1.3 ${DIR}/pool10 -X fail-safety)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool10)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool10)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool10)

	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.2 --to=1.3 ${DIR}/pool11 -X fail-safety)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool11)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool11)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool11)

	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.2 --to=1.3 ${DIR}/pool12 -X fail-safety)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool12)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool12)
	execute(0 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool12)
	execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool12)
endfunction(test)

# argument parsing
setup()

file(WRITE ${DIR}/pool10 "PMEMPOOLSET\n16M ${DIR}/part10\n")
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_10 ${DIR}/pool10)
execute(0 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert)
execute(0 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert ${DIR}/pool10)
execute(0 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=0.4 --to=1.1 ${DIR}/pool10)
execute(0 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.0 --to=1.10 ${DIR}/pool10)
execute(0 ${CMAKE_CURRENT_BINARY_DIR}/../pmdk-convert --from=1.3 --to=1.2 ${DIR}/pool10)


# single file pool
setup()

file(WRITE ${DIR}/pool10 "PMEMPOOLSET\n16M ${DIR}/part10\n")
file(WRITE ${DIR}/pool11 "PMEMPOOLSET\n16M ${DIR}/part11\n")
file(WRITE ${DIR}/pool12 "PMEMPOOLSET\n16M ${DIR}/part12\n")
file(WRITE ${DIR}/pool13 "PMEMPOOLSET\n16M ${DIR}/part13\n")

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_13 ${DIR}/pool13)

execute_process(COMMAND ${CMAKE_COMMAND} -E rename ${DIR}/part10 ${DIR}/pool10)
execute_process(COMMAND ${CMAKE_COMMAND} -E rename ${DIR}/part11 ${DIR}/pool11)
execute_process(COMMAND ${CMAKE_COMMAND} -E rename ${DIR}/part12 ${DIR}/pool12)
execute_process(COMMAND ${CMAKE_COMMAND} -E rename ${DIR}/part13 ${DIR}/pool13)

test()

# single file poolset
setup()

file(WRITE ${DIR}/pool10 "PMEMPOOLSET\n16M ${DIR}/part10\n")
file(WRITE ${DIR}/pool11 "PMEMPOOLSET\n16M ${DIR}/part11\n")
file(WRITE ${DIR}/pool12 "PMEMPOOLSET\n16M ${DIR}/part12\n")
file(WRITE ${DIR}/pool13 "PMEMPOOLSET\n16M ${DIR}/part13\n")

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_13 ${DIR}/pool13)

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool13)

test()

# multi file poolset
setup()

file(WRITE ${DIR}/pool10 "PMEMPOOLSET\n16M ${DIR}/part10_1 ${DIR}/part10_2\n")
file(WRITE ${DIR}/pool11 "PMEMPOOLSET\n16M ${DIR}/part11_1 ${DIR}/part11_2\n")
file(WRITE ${DIR}/pool12 "PMEMPOOLSET\n16M ${DIR}/part12_1 ${DIR}/part12_2\n")
file(WRITE ${DIR}/pool13 "PMEMPOOLSET\n16M ${DIR}/part13_1 ${DIR}/part13_2\n")

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_13 ${DIR}/pool13)

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool13)

test()

# poolset with local replica
setup()

file(WRITE ${DIR}/pool10 "PMEMPOOLSET\n16M ${DIR}/part10_rep1\nREPLICA\n16M ${DIR}/part10_rep2\n")
file(WRITE ${DIR}/pool11 "PMEMPOOLSET\n16M ${DIR}/part11_rep1\nREPLICA\n16M ${DIR}/part11_rep2\n")
file(WRITE ${DIR}/pool12 "PMEMPOOLSET\n16M ${DIR}/part12_rep1\nREPLICA\n16M ${DIR}/part12_rep2\n")
file(WRITE ${DIR}/pool13 "PMEMPOOLSET\n16M ${DIR}/part13_rep1\nREPLICA\n16M ${DIR}/part13_rep2\n")

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/create_13 ${DIR}/pool13)

execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_10 ${DIR}/pool10)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_11 ${DIR}/pool11)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_12 ${DIR}/pool12)
execute(1 ${CMAKE_CURRENT_BINARY_DIR}/open_13 ${DIR}/pool13)

test()

cleanup()