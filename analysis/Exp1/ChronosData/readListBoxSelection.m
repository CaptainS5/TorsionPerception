function [filesSelected] = readListBoxSelection(listbox)

filesSelected = {};
listEntries = get(listbox,'String');
indexSelected = get(listbox,'Value');
for i = 1:length(indexSelected)
filesSelected{i} = listEntries{indexSelected(i)};

end



end

