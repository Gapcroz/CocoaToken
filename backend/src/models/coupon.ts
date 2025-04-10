import { DataTypes, Model } from "sequelize";
import sequelize from "../config/database";
import User from "./user";

class Coupon extends Model {
  public id!: string;
  public name!: string;
  public description!: string;
  public socialEvent!: string;
  public tokensRequired!: number;
  public expirationDate!: Date;
  public status!: 'available' | 'used' | 'expired' | 'locked';
  public storeId!: number;
}

Coupon.init({
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  socialEvent: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  tokensRequired: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  expirationDate: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('available', 'used', 'expired', 'locked'),
    defaultValue: 'available',
    allowNull: false,
  },
  storeId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'Users',
      key: 'id',
    },
  },
}, {
  sequelize,
  modelName: 'Coupon',
  tableName: 'Coupons',
});

// Define the relationship with the User model
Coupon.belongsTo(User, { foreignKey: 'storeId', as: 'store' });
User.hasMany(Coupon, { foreignKey: 'storeId', as: 'coupons' });

export default Coupon; 