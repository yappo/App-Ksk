use inc::Module::Install;
name 'App-Ksk';
all_from 'lib/App/Ksk.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
