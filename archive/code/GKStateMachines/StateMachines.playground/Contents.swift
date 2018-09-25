//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

class OnState : GKState {}
class OffState : GKState {}

let onState = OnState()
let offState = OffState()

let lightStateMachine = GKStateMachine(states: [onState, offState])
lightStateMachine.enterState(OnState)

print(lightStateMachine.currentState! == onState)

let isON = lightStateMachine.currentState is OnState
let isOff = lightStateMachine.currentState is Off

switch (lightStateMachine.currentState) {
    case _ where lightStateMachine.currentState is OnState:
    print("on")
    case _ where lightStateMachine.currentState is OffState:
    print("off")
    default: break
}

class LightOn : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == LightOff.self
    }
}

class LightCooling : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == LightOn.self
    }
}
class LightOff : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == LightCooling.self
    }
}

let lightIsOn = LightOn()
let lightIsOff = LightOff()
let lightIsCooling = LightCooling()

let projectorStateMachine = GKStateMachine(states: [lightIsOn, lightIsOff, lightIsCooling])
projectorStateMachine.enterState(LightOff)

print(projectorStateMachine.enterState(LightOn))
print(projectorStateMachine.enterState(LightCooling))

func validClass(stateClass: AnyClass, toCheck: [AnyClass]) -> Bool {
    return toCheck.reduce(false) { (v, arg) in
        return v || stateClass == arg
    }
}

class Arrive : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Undecided.self])
    }
}

class Checking : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Selected.self, Reject.self])
    }
}
class Done : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Undecided.self])
    }
}
class EnRoute : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Reject.self, Thirsty.self, SeatSelection.self])
    }
}
class FindingBeverage : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [NoneAvailable.self, FoundBeverage.self])
    }
}
class FoundBeverage : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [EnRoute.self])
    }
}
class Listen : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Reject.self, Done.self])
    }}
class NoneAvailable : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [EnRoute.self])
    }}
class Reject : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Checking.self])
    }}
class SeatSelection : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Sit.self, Reject.self])
    }}
class Selected : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Reject.self,EnRoute.self])
    }}
class Sit : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Listen.self])
    }}
class Thirsty : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [FindingBeverage.self])
    }}
class Undecided : GKState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return validClass(stateClass, toCheck: [Checking.self])
    }
}

let attendeeStateMachine = GKStateMachine(states: [Arrive(), Undecided(), Checking(), Selected(), EnRoute(),Thirsty(), FindingBeverage(), NoneAvailable(), SeatSelection(),Sit(), Listen(), Done(), Reject()])

attendeeStateMachine.enterState(Arrive)
attendeeStateMachine.enterState(Thirsty)
attendeeStateMachine.enterState(Undecided)
