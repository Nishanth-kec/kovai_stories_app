import jwt from "jsonwebtoken";

export const generateToken = (user) => {
  return jwt.sign(
    {
      id: user._id,
      companyId: user.companyId,
      role: user.role
    },
    process.env.JWT_SECRET,
    { expiresIn: "12h" }
  );
};
