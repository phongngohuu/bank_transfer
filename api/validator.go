package api

import (
	"github.com/go-playground/validator/v10"
	"github.com/phongngohuu/bank_transfer/util"
)

var validCurrency validator.Func = func(fieldLever validator.FieldLevel) bool {
	if currency, ok := fieldLever.Field().Interface().(string); ok {
		//check currency is supported
		return util.IsSupportedCurrency(currency)
	}
	return false
}
