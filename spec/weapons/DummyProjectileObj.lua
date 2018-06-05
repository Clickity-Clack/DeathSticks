local DummyProjectileObj = class('dummyProjectile', Projectile)

function DummyProjectileObj:initialize(dummyWeapon)
    self.image = love.graphics.newImage()
    self.speed = 12
    self.shape = love.physics.newRectangleShape()
    Projectile.initialize(self, dummyWeapon)
end

return DummyProjectileObj
