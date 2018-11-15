local Jump = Component.create('Jump')

function Jump:initialize()
  self.time_min = 0.01
  self.time_max = 0.15

  self.cancelable = false

  self.force = -120

  self.wall = false
end

return Jump
