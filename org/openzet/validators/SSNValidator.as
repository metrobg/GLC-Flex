////////////////////////////////////////////////////////////////////////////////
//
//  	Copyright (C) 2009 VanillaROI Incorporated and its licensors.
//  	All Rights Reserved. 
//
//
//    	This file is part of OpenZet.
//
//    	OpenZet is free software: you can redistribute it and/or modify
//    	it under the terms of the GNU Lesser General Public License version 3 as published by
//    	the Free Software Foundation. 
//
//    	OpenZet is distributed in the hope that it will be useful,
//    	but WITHOUT ANY WARRANTY; without even the implied warranty of
//    	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    	GNU Lesser General Public License version 3 for more details.
//
//    	You should have received a copy of the GNU Lesser General Public License
//    	along with OpenZet.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////////////
package org.openzet.validators
{
import mx.validators.ValidationResult;
import mx.validators.Validator;
    
/**
 *  Custom Validator class for Korean SSN.
 */
public class SSNValidator extends Validator
{
    include "../core/Version.as";
    
    //--------------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------------

    /**
     * Constructor.
     */
    public function SSNValidator()
    {
        super();
    }

    //--------------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------------

    /**
     *  @private
     *  months array.
     */
    private var checkMonth:Array = [31, 29, 31, 30, 31, 30, 
                                    31, 31, 30, 31, 30, 31]; 

    /**
     *  @private
     */
    private var errorString:String;
    
    //--------------------------------------------------------------------------------
    //
    //  Overridden Method
    //
    //--------------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function doValidation(value:Object):Array
    {
        errorString = "";

        var results:Array = super.doValidation(value);
        
        if(results.length != 0)
        {
            return results;
        }
        
        var ssn:String = String(value);
        
        
        if(!(ssn.indexOf("-") == -1))
        {
            ssn = ssn.replace(new RegExp("-", "g"), "");
        }
        
        if(!isValidSSN(ssn))
        {
            if(errorString == null || errorString == "")
            {
                errorString = "주민등록번호가 일치하지 않습니다."
            }
            results.push(new ValidationResult(true, null, "Error", errorString));
        }
        
        return results;
    }
    
    //--------------------------------------------------------------------------------
    //
    //  Method
    //
    //--------------------------------------------------------------------------------
    
    /** 
     *  @private
     *  Checks whether SSN is valid.
     */
    protected function isValidSSN(ssn:String):Boolean
    {
        

        if (ssn.length != 13)
        {
            errorString = "주민등록번호 길이가 틀립니다."
            return false;
        }

        var mm:Number = Number(ssn.substr(2, 2));

        if (mm < 0 || mm > 12)
        {
            return false;
        }

        var dd:Number = Number(ssn.substr(4, 2));

        if (dd > checkMonth[mm - 1])
        {
            return false;
        }

        var ln:Number = Number(ssn.substr(6, 1));
        var isForeign:Boolean = (ln >= 5 && ln <= 8)

        if (isForeign)
        {
            var nnCheck:Number = (Number(ssn.substr(7, 1)) * 10) + Number(ssn.substr(8, 1));

            if (nnCheck % 2 != 0)
            {
                return false;
            }

            if (Number(ssn.substr(11, 1)) < 6)
            {
                return false;
            }
        }


        var check:String = "234567892345";
        var total:Number = 0;

        for (var i:int = 0; i < 12; i++)
        {
            total += Number(ssn.substr(i, 1)) * Number(check.substr(i, 1));
        }

        total = 11 - (total % 11);

        if (isForeign)
        {
            total += 2;
        }

        if (total >= 10)
        {
            total = total % 10;
        }

        if (Number(ssn.substr(12, 1)) != total)
        {
            return false;
        }
        
        return true;
    }
}
}