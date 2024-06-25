local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("Character")
PhysicsService:RegisterCollisionGroup("NoCollision")

PhysicsService:CollisionGroupSetCollidable("Character", "Character", false)

PhysicsService:CollisionGroupSetCollidable("NoCollision", "Default", false)
PhysicsService:CollisionGroupSetCollidable("NoCollision", "Character", false)
PhysicsService:CollisionGroupSetCollidable("NoCollision", "NoCollision", false)
