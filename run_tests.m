clc;

import matlab.unittest.TestSuite;
import matlab.unittest.TestRunner;
import matlab.unittest.Verbosity;
import matlab.unittest.plugins.CodeCoveragePlugin;
import matlab.unittest.plugins.codecoverage.CoverageReport;
import matlab.unittest.plugins.TestReportPlugin;

suite = TestSuite.fromPackage('tests', 'IncludingSubpackages', true);

runner = TestRunner.withTextOutput('Verbosity', Verbosity.Detailed);

runner.addPlugin(CodeCoveragePlugin.forPackage( ...
    {'live', 'data', 'models', 'config'}, ...
    'Producing', CoverageReport(fullfile(pwd, 'coverage_report'))));

runner.addPlugin(TestReportPlugin.producingHTML( ...
    fullfile(pwd, 'test_report')));

results = runner.run(suite);

disp(table(results));

failedCount = nnz(~[results.Passed]);
if failedCount > 0
    error('run_tests:failures', '%d test(s) failed.', failedCount);
end