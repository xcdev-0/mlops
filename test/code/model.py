import torch
import torch.nn as nn

class ModelClass(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(512, 256)
        self.fc2 = nn.Linear(256, 128)

    def forward(self, x):
        x = torch.relu(self.fc1(x))
        return self.fc2(x)
