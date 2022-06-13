from scipy.spatial.transform import Rotation as R

r = R.from_quat([0, 0, 0.707107, 0.707107])
print(r.as_euler('xyz', degrees=True))
