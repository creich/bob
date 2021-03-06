# This file holds common test functions and is sourced by run-tests.sh or the
# black box tests directly. It is not intended to be executed directly.

# Check if already sourced
if [[ "$(type -t run_bob)" == function ]] ; then
	return
fi

if [[ -d "pym/bob" ]] ; then
	BOB_ROOT="${PWD}"
elif [[ -d "../../pym/bob" ]] ; then
	BOB_ROOT="${PWD}/../.."
else
	echo "From where are you calling me?" >&2
	exit 1
fi

export PYTHONPATH="${BOB_ROOT}/pym"

cleanup()
{
	rm -rf work dev .bob-*
}

run_bob()
{
	${RUN:-python3} -m bob.scripts bob "$BOB_ROOT" "$@"
}

exec_blackbox_test()
{
	cleanup

	run_bob dev root > log.txt
	RES=$(sed -ne '/^Build result is in/s/.* //p' log.txt)
	diff -Nurp $RES output

	run_bob build root > log.txt
	RES=$(sed -ne '/^Build result is in/s/.* //p' log.txt)
	diff -Nurp $RES output

	run_bob clean
}
