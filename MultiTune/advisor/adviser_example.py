from .rl import RL


class CDBTUne(RL):
    def __init__(self, ):
        super().__init__()
        self.model = modelInit()

    def Suggest(self, context):
        return self.model.suggest(context)

    def UpdatePolicy(self, observation):
        self.model.updte(observation)

