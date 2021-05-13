function workspace_struct = workspace2struct_fun()

workspace_vars = evalin('caller', 'who');
    
    for i = 1:size(workspace_vars,1)
        thisvar = evalin('caller', workspace_vars{i});
        workspace.(workspace_vars{i}) = thisvar;
    end

workspace_struct = workspace;

end