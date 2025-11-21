-- used for debugging buttons clogging the navigation for gamepad

gui = game:GetService("GuiService")

while wait(1) do
if gui.SelectedObject then
print(gui.SelectedObject.Name, gui.SelectedObject.Parent.Name)
end
end