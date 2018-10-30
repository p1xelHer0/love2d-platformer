local Physics = Component.create('Physics')

function Physics:initialize()
  self.gravity = vector(0, 100)
end

return Physics
