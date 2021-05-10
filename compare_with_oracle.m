function [testresult] = compare_with_oracle(callervars, verbosity, folder, oracle_name, expected_passes, expected_fails, expected_unknown)
  O = load(strcat(folder, oracle_name));
  oraclevars = fieldnames(O);
  passed = {};
  failed = {};
  unknown = {};
  for i = 1:length(oraclevars)
    varname = oraclevars{i,1};
    a = O.(varname);
    try
      b = evalin('caller', varname);
    catch
      unknown = [unknown, varname];
      continue;
    end
    if (isequaln(a,b))
      passed = [passed, varname];
    else
      failed = [failed, varname];
    end
  end

if (verbosity > 1)
  for i = 1:length(failed)
    Ofail = O.(failed{i});
    Rfail = evalin('caller', failed{i});
    save(strcat(folder, 'Results/', int2str(i) ,"_O_", failed{i}, "_" ,oracle_name), "Ofail")
    save(strcat(folder, 'Results/', int2str(i) ,"_R_", failed{i}, "_" ,oracle_name), "Rfail")
  end
  
  type1_passes = setdiff(expected_passes, passed);
  type2_passes = setdiff(passed, expected_passes);
  type1_fails = setdiff(expected_fails, failed);
  type2_fails = setdiff(failed, expected_fails);
  type1_unknown = setdiff(expected_unknown, unknown);
  type2_unknown = setdiff(unknown, expected_unknown);
  disp("The following variables didn't match the Oracle when they should have:");
  disp(union(type1_passes, type2_fails));
  disp("The following variables matched the Oracle when they shouldn't have:");
  disp(union(type2_passes, type1_fails));
  disp("The following variables are unknown when they should not be:");
  disp(type1_unknown);
  disp("The following variables are not unknown when they should be:");
  disp(type2_unknown);
  
end

#  fidO = fopen('tests/testdata/Result/DATA_COVID_JHU_O.mat', 'w');
#  fidR = fopen('tests/testdata/Result/DATA_COVID_JHU_R.mat', 'w');

#  for i = 1:length(failed)
#    varname = failed{1,i};
#    fprintf(fidO, '%g\n', O.(varname));
#    fprintf(fidR, '%g\n', evalin('caller', varname));
#  end
    
#  fclose(fidO);
#  fclose(fidR);

  testresult.passed = passed;
  testresult.failed = failed;
  testresult.unknown = unknown;
end