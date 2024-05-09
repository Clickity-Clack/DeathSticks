local World = class('World')

function World:initialize()
    self.id = uuid()
    self.objects = {}
end

return World